document.getElementById('form-main').addEventListener('submit', function(event) {
    event.preventDefault(); // Prevent default form submission

    // Get the OTP value
    var otp = document.getElementById('otp').value;

    // Send data to API as JSON with OTP as Bearer token
    fetch('https://api.bta.corbinpersonal.me/operate', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + otp // Use OTP as Bearer token
        },
        body: JSON.stringify({
            shouldStart: document.getElementById('shouldStart').checked
        })
    })
    .then(response => {
        if (response.ok) {
            alert('Success');
        } else {
            alert('Error sending data:', response.statusText);
        }
    })
    .catch(error => {
        alert('Error:', error);
    });
});

