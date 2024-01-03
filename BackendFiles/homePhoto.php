<?php
include 'connection.php';



// Fetch photos along with user details by joining the post and user tables
$stmt = $conn->prepare("SELECT post.image, users.username, users.email, post.date 
                        FROM post 
                        JOIN users ON post.user_email = users.email 
                        ORDER BY post.date DESC");
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $data = array();

    while ($row = $result->fetch_assoc()) {
        $rowData = array(
            'image' => $row['image'],
            'username' => $row['username'],
            'email' => $row['email'],
            'date' => $row['date'] // Include the date in the response
        );
        $data[] = $rowData;
    }

    // Return the array of photo data sorted by date in descending order
    header('Content-Type: application/json');
    echo json_encode($data);
} else {
    echo json_encode(["message" => "No photos found in the database."]);
}


$conn->close();
?>
