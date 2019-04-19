<?php
	class Test {
	
		public function fun() {
			$Array = array();
			
			$Array['error'] = "910";
			$Array['test'] = "function test";
			if (DEBUG) $Array['debug'] = "debug test";
			
			return $Array;
		}
		
		public function funReq($req) {
			$Array['error'] = "910";
			$Array['test'] = "function req ".$req['test'];
		}
	
	}
?>
