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
		
		// Регистарция нового пользователя
		public function reg($req)
		{
			$Array = array();
			$name = $req['name'];
			$surname = $req['surname'];
			$mail = $req['mail'];
			$password = md5($req['password']);
			
			if (!empty($name) && !empty($surname) && !empty($mail) && !empty($password))
			{
				// TODO: проверка на наличие почты в бд
				// TODO: age, status
				$sql = "INSERT INTO create_event_users (name, surname, mail, password, img, age, ip, hash, date_time) VALUES ('$name', '$surname', '$mail', '$password', '0', '0', '0', '0', '2019-04-19 00:00:00.000000')";
				
				
				if (mysqli_query($this->conn, $sql))
				{
					$id = mysqli_insert_id($this->conn); // получение последнего id
					$idCode = base64_encode($this->strcode("$id", HACH_CODE)); // шифрование
					$Url = 'http://'.$_SERVER['HTTP_HOST'].'/user.activation?cod='.urlencode($idCode);
					
					require_once ROOT_API_DIR."support/SendMailSmtpClass.php";
					$mailSMTP = new SendMailSmtpClass(MAIL_ADDRESS, MAIL_PASSWORD, MAIL_HOST, MAIL_POSRT, 'UTF-8');
					
					// от кого
					$from = array(MAIL_NAME, MAIL_ADDRESS);
					
					// отправляем письмо
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
				
				// TODO: когда на сервере появится поле status				
				//$sql = "UPDATE create_event_users SET status=1 WHERE id=$UserID";
				
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
	
	}
?>
