<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:template match="/">
        <html>
            <body>
                <h1>ZESPOŁY:</h1>
                <ol>
                    <xsl:apply-templates select="ZESPOLY/ROW"/>
                </ol>
                <xsl:apply-templates select="ZESPOLY/ROW" mode="szczegoly"/>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="ROW">
        <li>
            <a href="#{position()}">
                <xsl:value-of select="NAZWA"/>
            </a>
        </li>
    </xsl:template>

    <xsl:template match="ROW" mode="szczegoly">
        <li>
            <a name="{position()}">
                <strong>
                    <xsl:value-of select="NAZWA"/>
                </strong>
            </a>
        </li>
        <li>
            <strong>
                <xsl:value-of select="ADRES"/>
            </strong>
        </li>
        <li>
            <xsl:if test="count(PRACOWNICY/ROW) > 0">
                <li>

                </li>
                <table border="1">
                    <tr>
                        <th>Nazwisko</th>
                        <th>Etat</th>
                        <th>Zatrudniony</th>
                        <th>Płaca pod.</th>
                        <th>Szef</th>
                    </tr>
                    <xsl:apply-templates select="PRACOWNICY/ROW" mode="dane_tabeli">
                        <xsl:sort select="NAZWISKO"/>
                    </xsl:apply-templates>
                </table>
            </xsl:if>
        </li>
        <li>
            Liczba pracowników: <xsl:value-of select="count(PRACOWNICY/ROW)"/>
        </li>
        <li>

        </li>
    </xsl:template>

    <xsl:template match="ROW" mode="dane_tabeli">
        <tr>
            <td><xsl:value-of select="NAZWISKO"/></td>
            <td><xsl:value-of select="ETAT"/></td>
            <td><xsl:value-of select="ZATRUDNIONY"/></td>
            <td><xsl:value-of select="PLACA_POD"/></td>
            <td>
                <xsl:choose>
                    <xsl:when test="//ROW[PRACOWNICY/ROW[ID_PRAC=current()/ID_SZEFA]]">
                        <xsl:value-of select="//ROW[PRACOWNICY/ROW[ID_PRAC=current()/ID_SZEFA]]/PRACOWNICY/ROW[ID_PRAC=current()/ID_SZEFA]/NAZWISKO"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:text>brak</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>