package com.mipt.alisa.web;

import com.mipt.alisa.socketserver.AlisaServer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.*;

public class AlisaServlet extends HttpServlet
{
    private AlisaServer alisaServer;

    private static String goalParameter = "goal";
    private static String registrationGoal = "reg";
    private static String authorizationGoal = "auth";
    private static String findUserGoal = "find";
    private static String addFriendGoal = "add";
    private static String startDialogGoal = "start";

    private static String loginParameter = "login";
    private static String passwordParameter = "pass";

    @Override
    public void init() throws ServletException
    {
        super.init();
        initDrawingServer();
    }

    private void initDrawingServer()
    {
        alisaServer = new AlisaServer();
        alisaServer.start();
    }

    private Connection getConnection() throws ClassNotFoundException, SQLException {
        // this will load the MySQL driver, each DB has its own driver
        Class.forName("com.mysql.jdbc.Driver");
        // setup the connection with the DB.
        return DriverManager.getConnection("jdbc:mysql://localhost/alisa", "alisaadmin", "alisapassword");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
    {
        String goal = req.getParameter(goalParameter);
        if (goal.equalsIgnoreCase(registrationGoal)) {
            String login = req.getParameter(loginParameter);
            String password = req.getParameter(passwordParameter);

            registration(login, password, resp);
        } else if (goal.equalsIgnoreCase(authorizationGoal)) {
            String login = req.getParameter(loginParameter);
            String password = req.getParameter(passwordParameter);

            authorization(login, password, resp);
        } else if (goal.equalsIgnoreCase(findUserGoal)) {

        } else if (goal.equalsIgnoreCase(addFriendGoal)) {

        } else if (goal.equalsIgnoreCase(startDialogGoal)) {

        }
    }

    private void registration(String login, String password, HttpServletResponse resp)
    {
        try {
            Connection connection = getConnection();
            Statement statement = connection.createStatement();

            String command = "insert into alisa.Users values ('" + login + "', '" + password + "')";

            statement.executeUpdate(command);

            statement.close();
            connection.close();

            resp.setStatus(1);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            resp.setStatus(0);
            e.printStackTrace();
        }
    }

    private void authorization(String login, String password, HttpServletResponse resp)
    {
        try {
            Connection connection = getConnection();
            Statement statement = connection.createStatement();

            String command = String.format("select * from users where login like '%s' and password like '%s'",
                    login, password);

            ResultSet resultSet = statement.executeQuery(command);

            if (resultSet.next()) {
                resp.setStatus(1);
            } else {
                resp.setStatus(2);
            }

            resultSet.close();
            statement.close();
            connection.close();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (SQLException e) {
            resp.setStatus(0);
            e.printStackTrace();
        }
    }

    private void findUser()
    {
    }

    private void addFriend()
    {
    }

    private void startDialog()
    {
    }
}