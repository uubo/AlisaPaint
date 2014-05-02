package com.mipt.alisa.socketserver;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AlisaServer extends Thread{

    private List<AlisaClient> clients = new ArrayList<AlisaClient>();
    private AlisaRoom globalRoom = new AlisaRoom(this);
    public static int PORT = 10023;

    @Override
    public void run()
    {
        try {
            ServerSocket serverSocket = new ServerSocket(PORT);
            for (;;) {
                Socket incoming = serverSocket.accept();
                AlisaClient client = new AlisaClient(globalRoom, incoming);
                client.start();

                System.out.printf("Client %d connected\n", clients.size());
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
        System.out.printf("Client %d disconnected\n", clientIndex);
        clients.remove(clientIndex);
    }
}
