package com.mipt.alisa.web;

import com.mipt.alisa.socketserver.AlisaServer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AlisaServlet extends HttpServlet
{
    private AlisaServer alisaServer;

    private static String goalParameter = "goal";
    private static String registrationGoal = "reg";
    private static String authorizationGoal = "auth";
    private static String findUserGoal = "find";
    private static String addFriendGoal = "add";
    private static String getFriendsGoal = "getf";
    private static String startDialogGoal = "start";

    private static String loginParameter = "login";
    private static String passwordParameter = "pass";
    private static String userLoginParameter = "user_login";
    private static String friendLoginParameter = "friend_login";

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
        if (goal.equalsIgnoreCase(registrationGoal))
        {
            String login = req.getParameter(loginParameter);
            String password = req.getParameter(passwordParameter);
            registration(login, password, resp);
        }
        else if (goal.equalsIgnoreCase(authorizationGoal))
        {
            String login = req.getParameter(loginParameter);
            String password = req.getParameter(passwordParameter);
            authorization(login, password, resp);
        }
        else if (goal.equalsIgnoreCase(findUserGoal))
        {
            String login = req.getParameter(loginParameter);
            findUser(login, resp);
        }
        else if (goal.equalsIgnoreCase(addFriendGoal))
        {
            String userLogin = req.getParameter(userLoginParameter);
            String friendLogin = req.getParameter(friendLoginParameter);
            addFriend(userLogin, friendLogin, resp);
        }
        else if (goal.equalsIgnoreCase(getFriendsGoal))
        {
            String login = req.getParameter(loginParameter);
            getFriends(login, resp);
        }
        else if (goal.equalsIgnoreCase(startDialogGoal)) {

        }
    }

    private void registration(String login, String password, HttpServletResponse resp)
    {
        try {
            Connection connection = getConnection();
            Statement statement = connection.createStatement();

            String command = "insert into users values ('" + login + "', '" + password + "')";

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

    private void findUser(String login, HttpServletResponse resp)
    {
        try {
            Connection connection = getConnection();
            Statement statement = connection.createStatement();

            String command = String.format("select * from users where login like '%s'",
                    login);

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

    private void addFriend(String userLogin, String friendLogin, HttpServletResponse resp)
    {
        try {
            Connection connection = getConnection();
            Statement statement = connection.createStatement();

            String command = String.format("select * from users where login like '%s'",
                    userLogin);

            ResultSet resultSet = statement.executeQuery(command);

            if (!resultSet.next()) {
                resp.setStatus(2);
            } else {
                command = String.format("select * from users where login like '%s'",
                        friendLogin);

                resultSet = statement.executeQuery(command);

                if (!resultSet.next()) {
                    resp.setStatus(2);
                } else {
                    command = String.format("insert into friends values ('%s', '%s')",
                            userLogin, friendLogin);

                    statement.executeUpdate(command);

                    resp.setStatus(1);
                }
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

    private void getFriends(String login, HttpServletResponse resp)
    {
        try {
            Connection connection = getConnection();
            Statement statement = connection.createStatement();

            String command = String.format("select * from users where login like '%s'", login);
            ResultSet resultSet = statement.executeQuery(command);

            if (resultSet.next()) {
                command = String.format("select * from friends where user_login like '%s'", login);
                resultSet = statement.executeQuery(command);

                PrintWriter writer = resp.getWriter();
                while (resultSet.next()) {
                    String friendLogin = resultSet.getString(2);
                    writer.println(friendLogin);
                }

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
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void startDialog()
    {
    }
}