<?php
include 'connection.php';


$query = $_POST['query'];
$excludeEmail = $_POST['excludeEmail'];

$sql = "SELECT username, email FROM users WHERE username LIKE '%$query%' AND email != '$excludeEmail'";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $users = array();
    while ($row = $result->fetch_assoc()) {
        $email = $row['email'];
        $photo_query = "SELECT image FROM post WHERE user_email = '$email' ORDER BY date DESC LIMIT 1";
        $photo_result = $conn->query($photo_query);
        $photo_row = $photo_result->fetch_assoc();
        
        $user_data = array(
            'username' => $row['username'],
            'email' => $row['email'],
            'image' => $photo_row ? $photo_row['image'] : '' // Check if $photo_row is valid
        );
        $users[] = $user_data;
    }

    header('Content-Type: application/json');
    echo json_encode($users);
} else {
    header('Content-Type: application/json');
    echo json_encode([]); // Return an empty array when there are no results
}

$conn->close();
?>
