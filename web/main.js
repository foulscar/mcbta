document.getElementById('form-main').addEventListener('submit', function(event) {
    event.preventDefault(); // Prevent default form submission

    // Get the OTP value
    var otpNUM = document.getElementById('otp').value;
    var otp = otpNUM.toString();

    // Send data to API as JSON with OTP as Bearer token
    fetch('https://cors-anywhere.herokuapp.com/https://api.bta.corbinpersonal.me/operate', {
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
      if (response.status === 403) {
        alert("OTP unauthorized. Try again.");
      }
      return response.json();
    })
    .then(data => {
      alert(data.message);
    })
    .catch(error => {
        alert('Error:', error);
    });
});

