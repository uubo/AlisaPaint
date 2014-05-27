package com.mipt.alisa.socketserver;

import java.io.*;
import java.net.Socket;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.List;

public class AlisaClient extends Thread {

    private String login;

    private AlisaServer server;
    private AlisaRoom room;
    private Socket socket;
    private DataInputStream in;
    private DataOutputStream out;

    private boolean authorized = false;

    public AlisaClient(AlisaServer server, Socket socket)
    {
        this.server = server;
        this.socket = socket;
    }

    public void run()
    {
        System.out.println("AlisaServer: Client thread started");
        try
        {
            out = new DataOutputStream(socket.getOutputStream());
            in = new DataInputStream(socket.getInputStream());

            int messageSize = 0;
            int bytesRead = 0;
            boolean waitingForNewMessage = true;
            boolean done = false;
            while (!done) {
                int bytesAvailable = in.available();
                if (bytesAvailable > 0) {
                    if (waitingForNewMessage) {
                        messageSize = in.readInt();
                        bytesAvailable -= Integer.SIZE / 8;
                        waitingForNewMessage = false;
                    }
                    byte[] message = new byte[messageSize];
                    in.read(message, bytesRead, bytesAvailable);
                    bytesRead += bytesAvailable;
                    if (bytesRead == messageSize) {
                        processMessage(message);
                        waitingForNewMessage = true;
                        bytesRead = 0;
                        messageSize = 0;
                    }
                }
            }
            socket.close();
            room.removeClient(this);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private static final short IdentificationMessageType = 1;
    private static final short RoomCreationMessageType = 2;

    private void processMessage(byte[] message)
    {
        DataInputStream messageDataIS = new DataInputStream(new ByteArrayInputStream(message));

        try {
            short messageType = messageDataIS.readShort();
            switch (messageType) {
                case IdentificationMessageType:
                    processIdentification(messageDataIS);
                    break;
                case RoomCreationMessageType:
                    processRoomCreation(messageDataIS);
                    break;
            }
            messageDataIS.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    private void processIdentification(DataInputStream messageIS)
    {
        try {
            short loginSize = messageIS.readShort();
            byte[] loginByteArray = new byte[loginSize];
            messageIS.read(loginByteArray);
            this.login = new String(loginByteArray, Charset.forName("UTF-8"));
            server.addClientLogin(this, this.login);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void sendIdentificationCompleted(boolean success)
    {

    }

    private void processRoomCreation(DataInputStream messageIS)
    {
        List<String> logins = new ArrayList<String>();
        try {
            short usersNumber = messageIS.readShort();
            for (short i = 0; i < usersNumber; i++) {
                short loginSize = messageIS.readShort();
                byte[] loginByteArray = new byte[loginSize];
                messageIS.read(loginByteArray);
                String login = new String(loginByteArray, Charset.forName("UTF-8"));
                logins.add(login);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        server.createRoom(this.login, logins);
    }

    public void send(byte[] buffer)
    {
        try {
            out.write(buffer);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public AlisaRoom getRoom() {
        return room;
    }

    public void setRoom(AlisaRoom room) {
        this.room = room;
    }

    public String getLogin() {
        return login;
    }
}
