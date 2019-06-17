<?php
	class User {
		
		public $conn;
		
		private function strcode($str, $passw="")
		{
			$salt = "Dn8*#2n!9j";
			$len = strlen($str);
			$gamma = '';
			$n = $len>100 ? 8 : 2;
			while(strlen($gamma) < $len)
			{
				$gamma .= substr(pack('H*', sha1($passw.$gamma.$salt)), 0, $n);
			}
			
			return $str^$gamma;
		}
		
		private function django_password_verify(string $password, string $djangoHash): bool
		{
			$pieces = explode('$', $djangoHash);
			if (count($pieces) !== 4) {
				throw new Exception("Illegal hash format");
			}
			list($header, $iter, $salt, $hash) = $pieces;
			// Get the hash algorithm used:
			if (preg_match('#^pbkdf2_([a-z0-9A-Z]+)$#', $header, $m)) {
				$algo = $m[1];
			} else {
				throw new Exception(sprintf("Bad header (%s)", $header));
			}
			if (!in_array($algo, hash_algos())) {
				throw new Exception(sprintf("Illegal hash algorithm (%s)", $algo));
			}
			
			$calc = hash_pbkdf2(
				$algo,
				$password,
				$salt,
				(int) $iter,
				32,
				true
			);
			return hash_equals($calc, base64_decode($hash));
		}
		
		
		// Регистарция нового пользователя
		public function reg($req)
		{
			$Array = array();
			$name = $req['name'];
			$surname = $req['surname'];
			$mail = $req['mail'];
			$password = md5($req['password']);
			$age = $req['age'];
			
			if (!empty($name) && !empty($surname) && !empty($mail) && !empty($password) && !empty($age))
			{
				$dateAge = date_create($age);
				$age = date_format($dateAge, "Y-m-d");
				$ip = ($_SERVER['REMOTE_ADDR'] ==  "::1") ? 'localhost' : $_SERVER['REMOTE_ADDR'];
				$today = date("Y-m-d H:i:s");
				
				$sql = "SELECT username FROM auth_user WHERE username = '$mail'";
				$count = mysqli_num_rows(mysqli_query($this->conn, $sql));
				
				if ($count == 0)
				{
					$iterations = 150000;
					$salt = md5(mt_rand());
					$hash = hash_pbkdf2("sha256", $password, $salt, $iterations, 32, true);
					$passwordString = "pbkdf2_sha256$$iterations$$salt$".base64_encode($hash);
					
// 					$sql = "INSERT INTO create_event_users (name, surname, mail, password, age, status, ip, date_time) VALUES ('$name', '$surname', '$mail', '$password', '$age', 0, '$ip', '$today')";
					$sql = "INSERT INTO auth_user (username, first_name, last_name, email, is_staff, is_active, is_superuser, password) VALUES ('$mail', '$name', '$surname', '$mail', 0, 0, 0, '$passwordString')";
					
					
					if (mysqli_query($this->conn, $sql))
					{
						$id = mysqli_insert_id($this->conn); // получение последнего id
						
						$sql = "INSERT INTO create_event_profile (age, user_id, ip) VALUES ('$age', '$id', '$ip')";
						mysqli_query($this->conn, $sql);
						
						
						$idCode = base64_encode($this->strcode("$id", HACH_CODE)); // шифрование
						$Url = 'http://'.$_SERVER['HTTP_HOST'].'/api/user.activation?cod='.urlencode($idCode);
						
						// Подкючение класса отправки писем через стороний сервер
						require_once ROOT_API_DIR."support/SendMailSmtpClass.php";
						$mailSMTP = new SendMailSmtpClass(MAIL_ADDRESS, MAIL_PASSWORD, MAIL_HOST, MAIL_POSRT, 'UTF-8');
						
						// От кого
						$from = array(MAIL_NAME, MAIL_ADDRESS);
						
						// Отправляем письмо
						$result =  $mailSMTP->send($mail, 'Тема письма', 'Для активации аккаунта перейдите по ссылке: '.$Url, $from); 
						
						if($result === true)
						{
							$Array['error'] = "910";
						}
						else
						{
							if (DEBUG) $Array['error_debug'] = $result;
							$Array['error'] = "900";
						}
						
					}
					else
					{
						if (DEBUG) $Array['error_debug'] = $sql."\n".mysqli_error($this->conn);
						$Array['error'] = "920";
					}
				}
				else
				{
					$Array['error'] = "912";
					if (DEBUG) $Array['error_debug'] = 'mysqli_num_rows: '.$count;
				}
			}
			else
			{
				$Array['error'] = "901";
			}
			
			return $Array;
		}
		
		// Активация аккаунта по ссылке из письма
		public function activation($req)
		{
			$Array = array();
			$cod = $req['cod'];
			
			if (!empty($cod))
			{
				$UserID = $this->strcode(base64_decode($cod), HACH_CODE);	
				$sql = "UPDATE auth_user SET is_active=1 WHERE id=$UserID";
				
				if (mysqli_query($this->conn, $sql))
				{
					$Array['error'] = "910";
				}
				else
				{
					if (DEBUG) $Array['error_debug'] = $sql."\n".mysqli_error($this->conn);
					$Array['error'] = "920";
				}
			}
			else
			{
				$Array['error'] = "901";
			}
			
			return $Array;
		}
		
		
		// Авторизация пользователя
		public function auth($req)
		{
			$Array = array();
			$mail = $req['mail'];
// 			$password = md5($req['password']);
			$password = $req['password'];
			
			if (!empty($mail) && !empty($password))
			{
				$sql = "SELECT
							auth_user.id,
							auth_user.email,
							auth_user.first_name,
							auth_user.last_name,
							auth_user.password,
							
							create_event_profile.age
						FROM
							auth_user,
							create_event_profile
						WHERE
							auth_user.username = '$mail' AND
							auth_user.is_active = 1 AND
							create_event_profile.user_id = auth_user.id";
				$result = mysqli_query($this->conn, $sql);
				$data = mysqli_fetch_assoc($result);
				
				$checkPassword = $this->django_password_verify($password, $data['password']);
				
				if (mysqli_num_rows($result) == 0 || $checkPassword != 1)
				{
					$Array['error'] = "900";
				}	
				else
				{
					$UserID = $data['id'];
					$token = md5($data['mail']).md5(rand(1000000, 9999999)); // генерация токена
					
					$sql = "UPDATE create_event_profile SET hash='$token' WHERE user_id=$UserID";

					if (mysqli_query($this->conn, $sql))
					{
						$Array['error'] = "910";
						$Array['token'] = $token;
						$Array['name'] = $data['first_name'];
						$Array['surname'] = $data['last_name'];
						$Array['mail'] = $data['email'];
						$Array['age'] = $data['age'];
					}
					else
					{
						if (DEBUG) $Array['error_debug'] = $sql."\n".mysqli_error($this->conn);
						$Array['error'] = "920";
					}
				}
			}
			else
			{
				$Array['error'] = "901";
			}
			
			return $Array;
		}
		
		public function edit($req)
		{
			$Array = array();
			$Token = $req['token'];
			
			$sql = "SELECT
						create_event_profile.user_id as id,
						auth_user.email
					FROM
						create_event_profile,
						auth_user
					WHERE
						create_event_profile.hash = '$Token' AND
						auth_user.id = create_event_profile.user_id";
			$result = mysqli_query($this->conn, $sql);
			
			if (mysqli_num_rows($result) > 0)
			{
				$data = mysqli_fetch_assoc($result);
				$UserID = $data['id'];
				$name = $req['name'];
				$surname = $req['surname'];
				$mail = $req['mail'];
				$age = $req['age'];
				$dateAge = date_create($age);
				$age = date_format($dateAge, "Y-m-d");
				
				if ($name != '' && $surname != '' && $age != '')
				{
					$sql = "SELECT username FROM auth_user WHERE username = '$mail'";
					$count = mysqli_num_rows(mysqli_query($this->conn, $sql));
					
					if ($count == 0)
					{
						$sql = "UPDATE
									create_event_profile,
									auth_user
								SET
									create_event_profile.age = '$age',
									auth_user.first_name = '$name',
									auth_user.last_name = '$surname'
								WHERE
									create_event_profile.user_id = $UserID AND
									auth_user.id = $UserID";
						
						if (mysqli_query($this->conn, $sql))
						{
							$Array['error'] = "910";
							$Array['age'] = $age;
						}
						else
						{
							if (DEBUG) $Array['error_debug'] = $sql."\n".mysqli_error($this->conn);
							$Array['error'] = "920";
						}
					}
					else
					{
						$Array['error'] = "912";
						if (DEBUG) $Array['error_debug'] = 'mysqli_num_rows: '.$count;
					}
				}
			}
			else
			{
				$Array['error'] = "900";
				if (DEBUG) $Array['error_debug'] = $sql."\n".mysqli_error($this->conn);
			}
			
			return $Array;

		}
		
		public function editPassword($req)
		{
			$Array = array();
			$passwordOld = $req['password_old'];
			$passwordNew = $req['password_new'];
			$token = $req['token'];
			
			if (!empty($token) && !empty($passwordOld) && !empty($passwordNew))
			{
				$sql = "SELECT
							auth_user.id,
							auth_user.password
						FROM
							auth_user,
							create_event_profile
						WHERE
							create_event_profile.hash = '$token' AND
							auth_user.id = create_event_profile.user_id";
				$result = mysqli_query($this->conn, $sql);
				$data = mysqli_fetch_assoc($result);
				
				$checkPassword = $this->django_password_verify($passwordOld, $data['password']);
				
				if (mysqli_num_rows($result) == 0 || $checkPassword != 1)
				{
					$Array['error'] = "900";
				}	
				else
				{
					$UserID = $data['id'];
					$iterations = 150000;
					$salt = md5(mt_rand());
					$hash = hash_pbkdf2("sha256", $passwordNew, $salt, $iterations, 32, true);
					$passwordString = "pbkdf2_sha256$$iterations$$salt$".base64_encode($hash);
					
					$sql = "UPDATE auth_user SET password='$passwordString' WHERE id=$UserID";

					if (mysqli_query($this->conn, $sql))
					{
						$Array['error'] = "910";
					}
					else
					{
						if (DEBUG) $Array['error_debug'] = $sql."\n".mysqli_error($this->conn);
						$Array['error'] = "920";
					}
				}
			}
			else
			{
				$Array['error'] = "901";
			}
			
			return $Array;
		}
		
	}
?>