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
    private Map<String, AlisaRoom> clientsRooms = new HashMap<String, AlisaRoom>();
    private AlisaRoom globalRoom = new AlisaRoom(this);
    private AlisaClient testClient = new AlisaClient(null, null);

    public static int PORT = 21021;

    @Override
    public void run()
    {
        System.out.println("AlisaServer: Starting...");
        AlisaRoom testRoom = new AlisaRoom(this);
        clientsRooms.put("login", testRoom);
        rooms.add(testRoom);

        try {
            ServerSocket serverSocket = new ServerSocket(PORT);
            for (;;) {
                Socket incoming = serverSocket.accept();
                AlisaClient client = new AlisaClient(globalRoom, incoming);
                client.start();

                System.out.printf("AlisaServer: Client %d connected\n", clients.size());
                clients.add(client);
                globalRoom.addClient(client);
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

    public void createRoom(List<String> logins)
    {
        AlisaRoom newRoom = new AlisaRoom(this);
        rooms.add(newRoom);
        for (String login : logins) {
            clientsRooms.put(login, newRoom);
        }
    }

    public AlisaRoom defineClientsRoom(AlisaClient client)
    {
        String login = client.getLogin();
        AlisaRoom room = clientsRooms.get(login);
        room.addClient(client);
        return room;
    }
    public static void main(String[] args)
    {
        AlisaServer server = new AlisaServer();
        server.start();
    }
}
