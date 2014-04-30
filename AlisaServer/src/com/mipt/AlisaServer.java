package com.mipt;

import java.io.IOException;
import java.net.ServerSocket;
import java.net.Socket;
import java.util.ArrayList;
import java.util.List;

public class AlisaServer {

    private List<AlisaClient> clients = new ArrayList<AlisaClient>();
    public static int PORT = 10022;

    public void start()
    {
        try {
            ServerSocket serverSocket = new ServerSocket(PORT);
            for (;;) {
                Socket incoming = serverSocket.accept();
                AlisaClient client = new AlisaClient(this, incoming);
                System.out.println("Client connected");
                clients.add(client);
                client.start();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void send(byte[] buffer, AlisaClient clientSender)
    {
        System.out.println(buffer);
        for (AlisaClient client : this.clients) {
            //if (client != clientSender) {
                client.send(buffer);
            //}
        }
    }

    public void removeClient(AlisaClient client)
    {
        clients.remove(client);
    }
}
