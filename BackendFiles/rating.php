<?php
include 'connection.php';


// Check if the request method is POST
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    
    // Retrieve the POST parameters: rating user's email, rated user's email, and rating
    $ratingUserEmail = $_POST['rating_user_email'] ?? '';
    $ratedUserEmail = $_POST['rated_user_email'] ?? '';
    $newRating = $_POST['rating'] ?? '';
    
    // Validate the incoming data (e.g., check if email and rating are not empty)
    if (!empty($ratingUserEmail) && !empty($ratedUserEmail) && !empty($newRating)) {
        

        // Check if a rating already exists for the same user
        $checkIfExists = "SELECT * FROM rating WHERE rateduser_email = '$ratedUserEmail' AND ratinguser_email = '$ratingUserEmail'";
        $result = $conn->query($checkIfExists);

        if ($result->num_rows > 0) {
            // If a record already exists, update the existing rating
            $updateRating = "UPDATE rating SET value = '$newRating' WHERE rateduser_email = '$ratedUserEmail' AND ratinguser_email = '$ratingUserEmail'";
            
            if ($conn->query($updateRating) === TRUE) {
                echo "Rating updated successfully";
            } else {
                echo "Error updating rating: " . $conn->error;
            }
        } else {
            $sql = "INSERT INTO rating (rateduser_email, ratinguser_email, value) VALUES ('$ratedUserEmail', '$ratingUserEmail', '$newRating')";
        
            if ($conn->query($sql) === TRUE) {
                echo "New rating inserted successfully";
            } else {
                echo "Error inserting rating: " . $conn->error;
            }
        }

        // Calculate the average rating for the rated user
        $averageRatingQuery = "SELECT AVG(value) AS average_rating FROM rating WHERE rateduser_email = '$ratedUserEmail'";
        $averageResult = $conn->query($averageRatingQuery);

        if ($averageResult->num_rows > 0) {
            $row = $averageResult->fetch_assoc();
            $averageRating = $row['average_rating'];

            // Update the 'rating' column in the 'user' table for the rated user
            $updateUserRating = "UPDATE users SET rating = '$averageRating' WHERE email = '$ratedUserEmail'";
            
            if ($conn->query($updateUserRating) === TRUE) {
                echo "Average rating updated in user table";
            } else {
                echo "Error updating average rating in user table: " . $conn->error;
            }
        } else {
            echo "No ratings found for this user";
        }

        $conn->close();
        
    } else {
        // Handle invalid or missing data
        echo "Invalid data received";
    }
    
} else {
    // Handle other request methods (if needed)
    echo "Invalid request method";
}
