<?php
	class Event {
		
		public $conn;
	
		public function get($req) {
			$Array = array();
			$ArrayEvents = array();
			$idEvent = $req['id'];
			$Today = $req['today'];
			$Date = $req['date'];
			
			if (!empty($idEvent))
			{
				$sqlForId = "create_event_event.id = '$idEvent' AND";
			}
			
			if ($Today == true)
			{
				$dateString = date('Y-m-d H:i:s');
				$dateTomorrow = date('Y-m-d 00:00:00', strtotime("+1 day"));
				$sqlDate = "(create_event_event.created_date >= '$dateString' AND create_event_event.created_date < '$dateTomorrow') AND";
			}
			else if (!empty($Date))
			{
				$date = date_create($Date);
				$date2 = date_create($Date);
				date_modify($date2, '+1 day');;
				$dateString = date_format($date, 'Y-m-d 00:00:00');
				$dateTomorrow = date_format($date2, 'Y-m-d 00:00:00');
				$sqlDate = "(create_event_event.created_date >= '$dateString' AND create_event_event.created_date < '$dateTomorrow') AND";
			}
			
			// TODO: tags
			$sql = "SELECT
						create_event_event.id,
						create_event_event.title,
						create_event_event.rating,
						create_event_event.price,
						create_event_event.description,
						create_event_event.main_photo,
						create_event_event.created_date,
						create_event_event.end_event,
						
						create_event_agerating.age_rating,
						
						create_event_organization.title as organization_title,
						
						auth_user.first_name as profile_name,
						auth_user.last_name as profile_surname
					FROM
						create_event_event,
						create_event_agerating,
						create_event_organization,
						auth_user
					WHERE
						$sqlForId
						$sqlDate
						create_event_agerating.id = create_event_event.age_rating_id AND
						create_event_event.status = 1 AND
						create_event_organization.id = create_event_event.id_venue_id AND
						auth_user.id = create_event_event.id_author_id
					ORDER BY create_event_event.created_date";
			$result = mysqli_query($this->conn, $sql);
			
			if (mysqli_num_rows($result) > 0)
			{
				while($row = mysqli_fetch_assoc($result))
				{
					array_push($ArrayEvents, $row);
				}
				
				$Array['events'] = $ArrayEvents;
				
				// ???
				// $Array['events'] = mysqli_fetch_array($result, MYSQLI_ASSOC);
				
				$Array['error'] = "910";
			}
			else
			{
				$Array['error'] = "900";
				if (DEBUG) $Array['error_debug'] = $sql."\n".mysqli_error($this->conn);
			}
			
			
			return $Array;
		}
		
		public function getAllDate($req) {
			$Array = array();
			$ArrayEventsDate = array();
			$dateToday = date('Y-m-d H:i:s');
			
			$sql = "SELECT
						create_event_event.created_date
					FROM
						create_event_event
					WHERE
						create_event_event.created_date > '$dateToday'
					ORDER BY create_event_event.created_date";
			$result = mysqli_query($this->conn, $sql);
			
			if (mysqli_num_rows($result) > 0)
			{
				while($row = mysqli_fetch_assoc($result))
				{
					$date = date_create($row['created_date']);
					$dateString = date_format($date, 'Y-m-d');
					
					if (!in_array($dateString, $ArrayEventsDate))
					{
						array_push($ArrayEventsDate, date_format($date, 'Y-m-d'));
					}
				}
				
				$Array['events'] = $ArrayEventsDate;
				$Array['error'] = "910";
			}
			else
			{
				$Array['error'] = "900";
				if (DEBUG) $Array['error_debug'] = $sql."\n".mysqli_error($this->conn);
			}
			
			return $Array;
		}
	
	}
?>
