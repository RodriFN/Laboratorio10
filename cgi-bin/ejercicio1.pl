#!/usr/bin/perl
use strict;
use warnings;
use CGI;
use DBI;

# Creamos el cgi
my $q=CGI->new;
print $q->header('text/html; charset=UTF-8');

# Configuración de conexión con la base de datos
my $database = "prueba";
my $hostname = "mariadb2"; #nombre del contenedor
my $port     = 3307;
my $user     = "rodrigo";
my $password = "12345";

# Conexión a la base de datos
my $dsn = "DBI:mysql:database=$database;host=$hostname;port=$port";
my $dbh = DBI->connect($dsn, 'rodrigo', 'tu_contraseña_segura', {
    RaiseError       => 1,
    PrintError       => 0,
    mysql_enable_utf8 => 1,
}) or die "<h1>Error al conectar a la base de datos: $DBI::errstr</h1>";

# Consulta
my $id = 5;
my $query = "SELECT * FROM actores WHERE actor_id = ?";
my $sth = $dbh->prepare($query);
$sth->execute($id);

# Ponemos los resultados en una variable para luego imprimirlos
my $resultados = "";
while (my @fila = $sth->fetchrow_array) {
    $resultados .= "<tr>\n";
    foreach my $dato (@fila) {
        $resultados .= "<td>$dato</td>\n";
    }
    $resultados .= "</tr>\n";
}

# HTML
print <<'HTML';
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/style.css">
    <title>Ejercicio 1</title>
</head>
<body>
    <h1>Actor con ID = 5</h1>
HTML

if (my @row = $sth->fetchrow_array) {
    print "<p>Nombre: $row[0]</p>";
} else {
    print "<p>No existe un actor con ID = 5.</p>";
}

print <<'HTML';
    <a href="/index.html">Volver al inicio</a>
</body>
</html>
HTML

$sth->finish();
$dbh->disconnect();