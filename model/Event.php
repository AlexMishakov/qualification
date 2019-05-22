<?php
	class Event {
		
		public $conn;
	
		public function get($req) {
			$Array = array();
			$ArrayEvents = array();
			$idEvent = $req['id'];
			$Today = $req['today'];
			$Date = $req['date'];
			$Free = $req['free'];
			$Text = $req['text'];
			$Tag = $req['tag'];
			
			if ($Tag != '') $idCategory = explode(",", $Tag);
			if ($Free == '') $Free = true;
			
			$dateString = date('Y-m-d H:i:s');
			
			if (!empty($idEvent))
			{
				$sqlForId = "create_event_event.id = '$idEvent' AND";
			}
			else if (count($idCategory) != 0)
			{
				$sqlTag = "create_event_event.id = create_event_tagscommunity.id_event_id AND";
				$sqlTagTransfer = "";
				for ($i = 0; $i < count($idCategory); $i++)
				{
					$idTag = $idCategory[$i];
					if ($idTag != 0)
					{
						$sqlTagTransfer .= "create_event_tagscommunity.id_tag_id = $idTag";
						if ($i != count($idCategory)-1) $sqlTagTransfer .= " OR ";
					}
				}
				
				$sqlTag .= " ($sqlTagTransfer) AND";
				$sqlTagTable = ", create_event_tagscommunity";
			}
			
			if ($Today == true)
			{
				$dateTomorrow = date('Y-m-d 00:00:00', strtotime("+1 day"));
				$sqlDate = "(create_event_event.created_date >= '$dateString' AND create_event_event.created_date <= '$dateTomorrow') AND";
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
			
			if ($Free == false)
			{
				$sqlFree = "NOT (create_event_event.price = 0) AND";
			}
			
			if ($Text != '')
			{
				// TODO: сделать более полноценный поиск
				// $sqlSerach = "MATCH (create_event_event.title, create_event_event.description) AGAINST ('$Text') AND";
				$sqlSerach = "(create_event_event.title LIKE '%$Text%' OR create_event_event.description LIKE '%$Text%') AND";
			}
			
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
						$sqlTagTable
					WHERE
						$sqlForId
						$sqlDate
						$sqlTag
						$sqlFree
						$sqlSerach
						create_event_agerating.id = create_event_event.age_rating_id AND
						create_event_event.status = 1 AND
						create_event_organization.id = create_event_event.id_venue_id AND
						create_event_event.created_date >= '$dateString'
					ORDER BY create_event_event.created_date LIMIT 50";
			$result = mysqli_query($this->conn, $sql);
			
			if (mysqli_num_rows($result) > 0)
			{
				while($row = mysqli_fetch_assoc($result))
				{
					$idEventRow = $row['id'];
					
					$sql = "SELECT
								create_event_tag.title,
								create_event_tag.id
							FROM
								create_event_tag,
								create_event_tagscommunity
							WHERE
								create_event_tag.id = create_event_tagscommunity.id_tag_id AND
								create_event_tagscommunity.id_event_id = $idEventRow";
					$resultTag = mysqli_query($this->conn, $sql);
					
					$ArrayTag = array();
					while($rowTag = mysqli_fetch_assoc($resultTag))
					{
						if ($rowTag['id'] != 0)
						{
							array_push($ArrayTag, $rowTag['title']);
						}
					}
										
					$sql = "SELECT
								create_event_morephotos.image
							FROM
								create_event_morephotos
							WHERE
								create_event_morephotos.event_id = $idEventRow";
					$resultImage = mysqli_query($this->conn, $sql);
					
					$ArrayImage = array();
					while($rowImage = mysqli_fetch_assoc($resultImage))
					{
						array_push($ArrayImage, $rowImage['image']);
					}
					
					$row['tag'] = $ArrayTag;
					$row['image'] = $ArrayImage;
					
					array_push($ArrayEvents, $row);
				}
				
				$Array['events'] = $ArrayEvents;
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
