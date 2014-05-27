package com.mipt.protocol.common;

import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.net.Socket;

public class InputListener extends Thread {
    protected Socket socket;
    protected DataInputStream in;
    protected DataOutputStream out;
    protected InputListenerDelegate delegate;

    public InputListener(Socket socket, InputListenerDelegate delegate) {
        super();
        this.socket = socket;
        this.delegate = delegate;
    }

    public void run() {
        try {
            in = new DataInputStream(socket.getInputStream());
            out = new DataOutputStream(socket.getOutputStream());
            this.delegate.setInputListener(this);

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
            closeSocket();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void closeSocket() {
        try {
            socket.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        stop();
    }

    public void processMessage(byte[] messageBytes) {
        DataInputStream is = new DataInputStream(new ByteArrayInputStream(messageBytes));
        try {
            short code = is.readShort();
            Class messageClass = delegate.messageClass(code);
            Constructor byteArrayConstructor = messageClass.getConstructor(new Class[]{byte[].class});
            Message message = (Message)byteArrayConstructor.newInstance(messageBytes);

            delegate.responseTo(message);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (NoSuchMethodException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        } catch (InstantiationException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        }
    }

    public void sendMessage(Message message) {
        try {
            out.write(message.toSend());
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
