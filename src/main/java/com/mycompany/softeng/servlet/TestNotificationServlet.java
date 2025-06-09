package com.mycompany.softeng.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class TestNotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>Notification Test</title></head>");
        out.println("<body>");
        out.println("<h2>Notification System Test</h2>");

        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        if (username == null) {
            out.println("<p style='color: red;'>No user logged in. Please <a href='login.jsp'>login</a> first.</p>");
        } else {
            out.println("<p style='color: green;'>Logged in as: " + username + "</p>");

            out.println("<h3>Test Notification Action</h3>");
            out.println("<button onclick='testNotificationAction()'>Test Accept Action</button>");
            out.println("<button onclick='testDeclineAction()'>Test Decline Action</button>");

            out.println("<div id='result' style='margin-top: 20px; padding: 10px; border: 1px solid #ccc;'>");
            out.println("Click a button to test notification actions...");
            out.println("</div>");
        }

        out.println("<script>");
        out.println("function testNotificationAction() {");
        out.println("  testAction('accept', '1', '1');");
        out.println("}");

        out.println("function testDeclineAction() {");
        out.println("  testAction('decline', '1', '1');");
        out.println("}");

        out.println("function testAction(action, notificationId, appointmentId) {");
        out.println("  document.getElementById('result').innerHTML = 'Testing ' + action + ' action...';");
        out.println("  fetch('notification-action', {");
        out.println("    method: 'POST',");
        out.println("    headers: {");
        out.println("      'Content-Type': 'application/x-www-form-urlencoded',");
        out.println("    },");
        out.println(
                "    body: 'action=' + action + '&notificationId=' + notificationId + '&appointmentId=' + appointmentId");
        out.println("  })");
        out.println("  .then(response => {");
        out.println("    console.log('Response status:', response.status);");
        out.println("    return response.text();");
        out.println("  })");
        out.println("  .then(data => {");
        out.println("    console.log('Response data:', data);");
        out.println(
                "    document.getElementById('result').innerHTML = '<strong>Response:</strong><br><pre>' + data + '</pre>';");
        out.println("  })");
        out.println("  .catch(error => {");
        out.println("    console.error('Error:', error);");
        out.println(
                "    document.getElementById('result').innerHTML = '<strong style=\"color: red;\">Error:</strong> ' + error.message;");
        out.println("  });");
        out.println("}");
        out.println("</script>");

        out.println("</body>");
        out.println("</html>");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}