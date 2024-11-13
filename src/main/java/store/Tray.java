package store;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class Tray {
    private int trayID;
    private int doughnutID;
    private int freshQty;
    private int totalQty;
    private Timestamp dateTime;

    ///getters and setters for Tray properties
    public int getTrayID() { 
    	return trayID; }
    public void setTrayID(int trayID) { 
    	this.trayID = trayID; }

    public int getDoughnutID() { 
    	return doughnutID; }
    public void setDoughnutID(int doughnutID) { 
    	this.doughnutID = doughnutID; }

    public int getFreshQty() { 
    	return freshQty; }
    public void setFreshQty(int freshQty) { 
    	this.freshQty = freshQty; }

    public int getTotalQty() { 
    	return totalQty; }
    public void setTotalQty(int totalQty) { 
    	this.totalQty = totalQty; }

    public Timestamp getDateTime() { 
    	return dateTime; }
    public void setDateTime(Timestamp dateTime) { 
    	this.dateTime = dateTime; }

    ///method to fetch all trays from the database
    public static List<Tray> getAllTrays() {
        List<Tray> trays = new ArrayList<>();
        try (Connection conn = Database.getConnection()) {
            String query = "SELECT * FROM Trays";
            PreparedStatement stmt = conn.prepareStatement(query);
            ResultSet rs = stmt.executeQuery();
            
            while (rs.next()) {
                Tray tray = new Tray();
                tray.setTrayID(rs.getInt("TrayID"));
                tray.setDoughnutID(rs.getInt("DoughnutID"));
                tray.setFreshQty(rs.getInt("FreshQty"));
                tray.setTotalQty(rs.getInt("TotalQty"));
                tray.setDateTime(rs.getTimestamp("DateTime"));
                trays.add(tray);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return trays;
    }

    ///method to update a tray
    public static void updateTray(int trayID, int freshQty, int totalQty) {
        try (Connection conn = Database.getConnection()) {
            String query = "UPDATE Trays SET FreshQty = ?, TotalQty = ? WHERE TrayID = ?";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, freshQty);
            stmt.setInt(2, totalQty);
            stmt.setInt(3, trayID);
            stmt.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    ///method to add a new tray
    public static void addTray(int doughnutID, int freshQty, int totalQty) {
        try (Connection conn = Database.getConnection()) {
            String query = "INSERT INTO Trays (DoughnutID, FreshQty, TotalQty, DateTime) VALUES (?, ?, ?, NOW())";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setInt(1, doughnutID);
            stmt.setInt(2, freshQty);
            stmt.setInt(3, totalQty);
            stmt.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
