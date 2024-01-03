<?php

include 'connection.php';

// Check if the image data and email have been sent
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['image']) && isset($_POST['email'])) {
    // Decode base64 image data
    $base64Image = $_POST['image'];
    $imageData = base64_decode($base64Image);

    // Get user's email and sanitize it
    $userEmail = $_POST['email'];
    $sanitizedEmail = filter_var($userEmail, FILTER_SANITIZE_EMAIL);

    // Directory to store uploaded images
    $uploadPath = './uploads/'; // Change this to your desired directory

    // Create directory if it doesn't exist
    if (!file_exists($uploadPath)) {
        mkdir($uploadPath, 0777, true);
    }

    // Generate a unique filename for the image
    $imageName = uniqid() . '.jpg'; // You can modify the file extension based on your image type

    // Path to store the image
    $imagePath = $uploadPath . $imageName;

    // Write image data to the file
    $file = fopen($imagePath, 'wb');
    fwrite($file, $imageData);
    fclose($file);

 $imageurl = 'https://socialrankbysalam.000webhostapp.com/uploads/'.$imageName;


    // Check if image was successfully saved
    if (file_exists($imagePath)) {
        // Prepare and execute SQL statement to insert post data into the database
        $stmt = $conn->prepare("INSERT INTO post (image, user_email) VALUES (?, ?)");
        $stmt->bind_param("ss", $imageurl, $sanitizedEmail);
        $stmt->execute();
        $stmt->close();
        $conn->close();

        $response = [
            'success' => true,
            'message' => 'Post uploaded and stored successfully.',
            'image_path' => $imagePath // Optionally, you can send back the image path for reference
        ];
        echo json_encode($response);
    } else {
        $response = [
            'success' => false,
            'message' => 'Failed to upload post.'
        ];
        echo json_encode($response);
    }
} else {
    $response = [
        'success' => false,
        'message' => 'No image data or email received.'
    ];
    echo json_encode($response);
}
?>
