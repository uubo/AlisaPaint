package com.mipt.alisa.socketserver;

import java.util.ArrayList;
import java.util.List;

public class AlisaRoom
{
    private String name;
    private List<AlisaClient> clients = new ArrayList<AlisaClient>();
    private AlisaServer server;

    private List<byte[]> messages = new ArrayList<byte[]>();

    public AlisaRoom(AlisaServer server)
    {
        this.server = server;
    }

    public void addClient(AlisaClient client)
    {
        clients.add(client);
        for (byte[] message : messages) {
            client.send(message);
        }
    }

    public void removeClient(AlisaClient client)
    {
        clients.remove(client);
        server.removeClient(client);
    }

    public void sendMessageFrom(AlisaClient sender, byte[] message)
    {
        for (AlisaClient client : this.clients) {
            //if (client != sender) {
                client.send(message);
            //}
        }
        messages.add(message);
    }
}
