<?php
	class DataBase {
		
		private $host = DB_HOST;
		private $username = DB_USER;
		private $password = DB_PASSWORD;
		
		public $database;
		public $connection;
		
		// получить подключение к бд
		public function getConnection() {
			
			$this->connection = null;
			
			if ($this->database != null)
			{
				// Создание подключения
				$this->connection = new mysqli($this->host, $this->username, $this->password, $this->database);
				
				// Проверка подключения
				if ($this->connection->connect_error) {
					die("Connection failed: " . $this->connection->connect_error);
				}
			}
			
			return $this->connection;
		}
	}
?>
