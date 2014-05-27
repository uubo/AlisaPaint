package com.mipt.alisa.socketserver;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AlisaServer extends Thread{

    private List<AlisaClient> clients = new ArrayList<AlisaClient>();
    private List<AlisaRoom> rooms = new ArrayList<AlisaRoom>();
    private Map<String, AlisaClient> logins = new HashMap<String, AlisaClient>();

    public static final int PORT = 21022;

    @Override
    public void run()
    {
        System.out.println("AlisaServer: Starting...");

        try {
            ServerSocket serverSocket = new ServerSocket(PORT);
            for (;;) {
                Socket incoming = serverSocket.accept();
                AlisaClient client = new AlisaClient(this, incoming);
                client.start();

                System.out.printf("AlisaServer: Client %d connected\n", clients.size());
                clients.add(client);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void removeClient(AlisaClient client)
    {
        int clientIndex = clients.indexOf(client);
        System.out.printf("AlisaServer: Client %d disconnected\n", clientIndex);
        clients.remove(clientIndex);
    }

    public void addClientLogin(AlisaClient client, String login)
    {
        logins.put(login, client);
        client.sendIdentificationCompleted(true);
    }

    public void createRoom(String creatorLogin, List<String> loginsInRoom)
    {
        AlisaClient creator = logins.get(creatorLogin);
        creator.sendRoomCreationCompleted(true);

        for (String login : loginsInRoom) {
            AlisaClient client = logins.get(login);
            client.sendYouAreAddedToTheRoom();
        }
    }

    public static void main(String[] args)
    {
        AlisaServer server = new AlisaServer();
        server.start();
    }
}
