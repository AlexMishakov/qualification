<?php
	require_once('support/Config.php');
	require_once('support/SimpleRest.php');
	require_once('support/DataBase.php');
	
	$SimpleRest = new SimpleRest();
	// Подключение к бд
	$DB = new DataBase();
	$DB->database = 'qualification';
	$con = $DB->getConnection();
	
	$model = isset($_GET["model"]) ? ucfirst($_GET["model"]) : "";
	$function = isset($_GET["fun"]) ? $_GET["fun"] : "";
	
	// Формирование и чистка запроса
	$request = $_REQUEST;
	unset($request['model']);
	unset($request['fun']);
	
	// Проврка названия модели
	if ($model == "")
	{
		$SimpleRest->setHttpHeadersAndPrint($_SERVER['HTTP_ACCEPT'], 404);
	}
	else
	{
		require_once('model/'.$model.'.php');
		$obj = new $model();
		$obj->conn = $con;
		
		// Проверка названия метода
		if (method_exists($model, $function))
		{
			// Вызов метода
			$response = $obj->$function($request);
			echo json_encode($response, JSON_PRETTY_PRINT);
			
			// TODO: в завсисимости от ошибки менять заголовок
		}
		else
		{
			$SimpleRest->setHttpHeadersAndPrint($_SERVER['HTTP_ACCEPT'], 404);
		}
	}
?>
