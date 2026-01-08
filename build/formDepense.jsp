<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="oo.Depense" %>
<%@ page import="oo.Credit" %>

<% List<Credit> credits = (List<Credit>) request.getAttribute("credit"); %>
<% List<Depense> depenses = (List<Depense>) request.getAttribute("depense"); %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>credit</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style-common.css"></head>
<body>
    <div class="container">
        <nav class="navbar">
            <div class="logo">
                <h2>ExamApp</h2>
            </div>
            <ul class="nav-links">
                <li><a href="${pageContext.request.contextPath}/Accueil.jsp" class="active">Accueil</a></li>
                <li><a href="${pageContext.request.contextPath}/formCredit.jsp" class="active">Credit</a></li>
                <li><a href="${pageContext.request.contextPath}/depense" class="active">Depense</a></li>
                <li><a href="${pageContext.request.contextPath}/dashboard" class="active">Dashboard</a></li>
            </ul>
        </nav>
        
        <div class="main-content">
            <h1>Ajouter Une Ligne de Depense</h1>
            
            <form action="${pageContext.request.contextPath}/depense" method="post" class="form">
    
            <div class="form-group">
                <p>Choisir Une Libelle<p>
                <select name="idcredit"required>
                    <option value="" name= "libelle">Sélectionner un Libelle</option>
                    <% 
                        if (credits != null) {
                            for (Credit cre : credits) { 
                    %>
                    <option value="<%= cre.getId() %>"><%= cre.getLibelle() %></option>
                    <% 
                            }
                        } 
                    %>
                </select>
            </div>     
                
                <div class="form-group">
                    <label for="montant">Montant:</label>
                    <input type="number" id="montant" name="montant" required>
                </div>
                
                <div class="form-buttons">
                    <button type="submit" class="btn btn-primary">Enregistrer</button>
                    <a href="index.jsp" class="btn">Annuler</a>
                </div>
            </form>
        </div>
        
    </div>
</body>
</html>