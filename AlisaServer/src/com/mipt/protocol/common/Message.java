package com.mipt.protocol.common;


import java.io.ByteArrayInputStream;
import java.io.DataInputStream;
import java.io.IOException;
import java.lang.reflect.Field;
import java.nio.charset.Charset;

/*
Что можно хранить в сообщении?
1) Все примитивные типы
2) Их массивы
3) Строки

При считывании перед массивами и строками всегда идет их размер.
Со стороками еще как-то нужно увязать кодировку.
 */

public abstract class Message {

    public abstract short code();

    public Message(byte[] byteArray) {
        DataInputStream dataInputStream = new DataInputStream(new ByteArrayInputStream(byteArray));
        try {
            // skip message code value
            // we use explicit constructor instead
            dataInputStream.skipBytes(Short.SIZE / 8);
        } catch (IOException e) {
            e.printStackTrace();
        }

        Field[] fields = this.getClass().getDeclaredFields();
        for (Field field : fields) {
            Class fieldClass = field.getType();
            String fieldClassName = fieldClass.getName();

            try {
                if (fieldClassName.equalsIgnoreCase("java.lang.String")) {
                    int size = dataInputStream.readInt();
                    byte[] data = new byte[size];
                    dataInputStream.read(data);
                    String string = new String(data, Charset.forName("UTF-8"));
                    field.set(this, string);
                }
            } catch (IOException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }
        }
    }

    public Message() {}

    public byte[] toByteArray() {
        byte[] res = toByteArray(code());

        Field[] fields = this.getClass().getDeclaredFields();
        for (int i = 0; i < fields.length; i++) {
            Field field = fields[i];
            Class fieldClass = field.getType();
            String fieldClassName = fieldClass.getName();

            byte[] fieldBytes = null;
            try {
                if (fieldClassName.equalsIgnoreCase("java.lang.String")) {
                    String string = (String) field.get(this);
                    int len = string.length();
                    byte[] lenBytes = toByteArray(len);
                    byte[] strBytes = string.getBytes(Charset.forName("UTF-8"));
                    fieldBytes = concat(lenBytes, strBytes);
                }
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            }

            res = concat(res, fieldBytes);
        }
        return res;
    }

    public byte[] toSend() {
        byte[] message = toByteArray();
        return concat(toByteArray(message.length), message);
    }

    public static byte[] concat(byte[] a, byte[] b) {
        byte[] res = new byte[a.length + b.length];
        System.arraycopy(a, 0, res, 0, a.length);
        System.arraycopy(b, 0, res, a.length, b.length);
        return res;
    }

    public static byte[] toByteArray(final int integer) {
        byte[] result = new byte[4];

        result[0] = (byte)((integer & 0xFF000000) >> 24);
        result[1] = (byte)((integer & 0x00FF0000) >> 16);
        result[2] = (byte)((integer & 0x0000FF00) >> 8);
        result[3] = (byte)(integer & 0x000000FF);

        return result;
    }

    public static byte[] toByteArray(final short integer) {
        byte[] result = new byte[2];

        result[0] = (byte)((integer & 0x0000FF00) >> 8);
        result[1] = (byte)(integer & 0x000000FF);

        return result;
    }
}
