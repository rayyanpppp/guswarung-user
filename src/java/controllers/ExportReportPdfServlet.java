package controllers;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

import models.Inventaris;
import models.InventarisDAO;
import models.OrderDAO;

@WebServlet("/ExportReportPdf")
public class ExportReportPdfServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/pdf");
        response.setHeader(
            "Content-Disposition",
            "attachment; filename=laporan_guswarung.pdf"
        );

        try {
            Document document = new Document(PageSize.A4);
            PdfWriter.getInstance(document, response.getOutputStream());
            document.open();

            Font titleFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 16);
            Font headerFont = FontFactory.getFont(FontFactory.HELVETICA_BOLD, 11);
            Font bodyFont = FontFactory.getFont(FontFactory.HELVETICA, 10);

            // ================= JUDUL =================
            Paragraph title = new Paragraph("LAPORAN GUS WARUNG\n\n", titleFont);
            title.setAlignment(Element.ALIGN_CENTER);
            document.add(title);

            // ================= RINGKASAN PENJUALAN =================
            OrderDAO orderDAO = new OrderDAO();

            Paragraph salesTitle = new Paragraph("Ringkasan Penjualan\n", headerFont);
            document.add(salesTitle);

            document.add(new Paragraph(
                "Pendapatan Hari Ini : Rp " + orderDAO.getRevenueToday(), bodyFont
            ));
            document.add(new Paragraph(
                "Pendapatan Bulan Ini : Rp " + orderDAO.getRevenueThisMonth(), bodyFont
            ));

            document.add(new Paragraph("\n"));

            // ================= LAPORAN STOK =================
            Paragraph stockTitle = new Paragraph("Laporan Stok Inventaris\n\n", headerFont);
            document.add(stockTitle);

            PdfPTable table = new PdfPTable(3);
            table.setWidthPercentage(100);
            table.setWidths(new float[]{4, 2, 2});

            table.addCell(new PdfPCell(new Phrase("Nama Barang", headerFont)));
            table.addCell(new PdfPCell(new Phrase("Stok", headerFont)));
            table.addCell(new PdfPCell(new Phrase("Status", headerFont)));

            InventarisDAO inventarisDAO = new InventarisDAO();
            List<Inventaris> list = inventarisDAO.getInventarisForReport();

            for (Inventaris i : list) {
                table.addCell(new Phrase(i.getName(), bodyFont));
                table.addCell(new Phrase(
                    i.getQuantity() + " " + i.getUnit(), bodyFont
                ));
                table.addCell(new Phrase(i.getStatus(), bodyFont));
            }

            document.add(table);
            document.close();

        } catch (Exception e) {
            throw new ServletException(e);
        }
    }
}