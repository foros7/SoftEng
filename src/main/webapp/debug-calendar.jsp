<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Calendar Debug</title>
</head>
<body>
    <h1>Calendar Data Debug</h1>
    <button onclick="testCalendarData()">Test Calendar Data</button>
    <div id="output"></div>

    <script>
        function testCalendarData() {
            console.log('Testing calendar data endpoint...');
            fetch('professor-appointments?action=getCalendarData')
                .then(response => {
                    console.log('Response status:', response.status);
                    console.log('Response headers:', response.headers);
                    return response.text();
                })
                .then(text => {
                    console.log('Raw response:', text);
                    document.getElementById('output').innerHTML = '<pre>' + text + '</pre>';
                    try {
                        const data = JSON.parse(text);
                        console.log('Parsed JSON:', data);
                    } catch (e) {
                        console.error('JSON parse error:', e);
                    }
                })
                .catch(error => {
                    console.error('Fetch error:', error);
                    document.getElementById('output').innerHTML = 'Error: ' + error.message;
                });
        }
    </script>
</body>
</html> 