package store;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/MenuEdit")
@MultipartConfig(
		fileSizeThreshold = 1024 * 1024 * 2, // 2MB
		maxFileSize = 1024 * 1024 * 10, // 10MB
		maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class Doughnut extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private int id;
	private String name;
	private String description;
	private double price;
	private boolean status;
	private int categoryID;
	private String categoryName;

	public Doughnut() {
	}

	public Doughnut(int id, String name, String description, double price, boolean status, int categoryID,
			String categoryName) {
		this.id = id;
		this.name = name;
		this.description = description;
		this.price = price;
		this.status = status;
		this.categoryID = categoryID;
		this.categoryName = categoryName;
	}

    public int getId() { return id; }
    public String getName() { return name; }
    public String getDescription() { return description; }
    public double getPrice() { return price; }
    public boolean getStatus() { return status; }
    public int getCategoryID() { return categoryID; }
    public String getCategoryName() { return categoryName; }

	private static Doughnut queryDoughnut(ResultSet resultSet) throws SQLException {
		return new Doughnut(resultSet.getInt("DoughnutID"), resultSet.getString("Name"),
				resultSet.getString("Description"), resultSet.getDouble("Price"), resultSet.getBoolean("Status"),
				resultSet.getInt("CategoryID"), resultSet.getString("CategoryName"));
	}

	public static List<Doughnut> getDoughnuts() {
		List<Doughnut> doughnuts = new ArrayList<>();
		String query = "SELECT d.DoughnutID, d.Name, d.Description, d.Price, d.Status, d.CategoryID, c.Name AS CategoryName "
				+ "FROM Doughnuts d " + "JOIN Category c ON d.CategoryID = c.CategoryID";

		try (Connection connection = Database.getConnection();
				PreparedStatement statement = connection.prepareStatement(query);
				ResultSet resultSet = statement.executeQuery()) {

			while (resultSet.next()) {
				doughnuts.add(queryDoughnut(resultSet));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return doughnuts;
	}

	public static Doughnut getDoughnutById(int doughnutId) {
		Doughnut doughnut = null;
		String query = "SELECT d.DoughnutID, d.Name, d.Description, d.Price, d.Status, d.CategoryID, c.Name AS CategoryName "
				+ "FROM Doughnuts d " + "JOIN Category c ON d.CategoryID = c.CategoryID " + "WHERE d.DoughnutID = ?";

		try (Connection connection = Database.getConnection();
				PreparedStatement statement = connection.prepareStatement(query)) {
			statement.setInt(1, doughnutId);

			try (ResultSet resultSet = statement.executeQuery()) {
				if (resultSet.next()) {
					doughnut = queryDoughnut(resultSet);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return doughnut;
	}

	public static List<String> getCategories() {
		List<String> categories = new ArrayList<>();
		try (Connection connection = Database.getConnection();
				PreparedStatement statement = connection.prepareStatement("SELECT Name FROM Category");
				ResultSet resultSet = statement.executeQuery()) {
			while (resultSet.next()) {
				categories.add(resultSet.getString("Name"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return categories;
	}

	public static int getCategoryIdByName(String categoryName) {
		try (Connection connection = Database.getConnection();
				PreparedStatement statement = connection
						.prepareStatement("SELECT CategoryID FROM Category WHERE Name = ?")) {
			statement.setString(1, categoryName);
			try (ResultSet resultSet = statement.executeQuery()) {
				if (resultSet.next()) {
					return resultSet.getInt("CategoryID");
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public static void insertDoughnut(String name, String description, double price, boolean status, int categoryID) {
		try (Connection connection = Database.getConnection();
				PreparedStatement statement = connection.prepareStatement(
						"INSERT INTO Doughnuts (Name, Description, Price, Status, CategoryID) VALUES (?, ?, ?, ?, ?)")) {
			statement.setString(1, name);
			statement.setString(2, description);
			statement.setDouble(3, price);
			statement.setBoolean(4, status);
			statement.setInt(5, categoryID);
			statement.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void updateDoughnut(int id, String name, String description, double price, boolean status,
			int categoryID) {
		try (Connection connection = Database.getConnection();
				PreparedStatement statement = connection.prepareStatement(
						"UPDATE Doughnuts SET Name = ?, Description = ?, Price = ?, Status = ?, CategoryID = ? WHERE DoughnutID = ?")) {
			statement.setString(1, name);
			statement.setString(2, description);
			statement.setDouble(3, price);
			statement.setBoolean(4, status);
			statement.setInt(5, categoryID);
			statement.setInt(6, id);
			statement.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		try {
			String action = request.getParameter("action");
			if ("saveData".equals(action)) {
				int id = Integer.parseInt(request.getParameter("doughnutId"));
				String name = request.getParameter("name_" + id);
				String description = request.getParameter("description_" + id);
				double price = Double.parseDouble(request.getParameter("price_" + id));
				int category = getCategoryIdByName(request.getParameter("category_" + id));
				boolean status = request.getParameter("status_" + id) != null;
				updateDoughnut(id, name, description, price, status, category);
				response.sendRedirect("MenuEdit.jsp");
			} else if ("insert".equals(action)) {
				String name = request.getParameter("name_new");
				String description = request.getParameter("description_new");
				double price = Double.parseDouble(request.getParameter("price_new"));
				boolean status = request.getParameter("status_new") != null;
				int categoryID = getCategoryIdByName(request.getParameter("category_new"));
				insertDoughnut(name, description, price, status, categoryID);
				response.sendRedirect("MenuEdit.jsp");
			} else if ("saveImage".equals(action)) {
				int id = Integer.parseInt(request.getParameter("doughnutId"));
				Part filePart = request.getPart("file_" + id);
				if (filePart != null && filePart.getSize() > 0) {
					String fileName = filePart.getSubmittedFileName();
					if (fileName.endsWith(".png")) {
						String uploadPath = getServletContext().getRealPath("") + "images";
						File uploadDir = new File(uploadPath);
						if (!uploadDir.exists())
							uploadDir.mkdirs();
						String filePath = uploadPath + File.separator + id + ".png";
						filePart.write(filePath);
						response.sendRedirect("MenuEdit.jsp");
						System.out.println("Base path: " + getServletContext().getRealPath(""));
						System.out.println("Upload path: " + uploadPath);
						System.out.println("File path: " + filePath);

					} else {
						response.setContentType("text/plain");
						response.getWriter().write("Error: Only PNG files are allowed.");
					}
				} else {
					response.setContentType("text/plain");
					response.getWriter().write("Error: No image provided.");
				}
			} else {
				response.setContentType("text/plain");
				response.getWriter().write("Error: Invalid action.");
			}
		} catch (Exception e) {
			e.printStackTrace();
			response.setContentType("text/plain");
			response.getWriter().write("Error: Something went wrong.");
		}
	}
}
