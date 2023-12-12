let $idZesp := doc('file:///C:/Users/kowal/Desktop/XPath-XSLT/zesp_prac.xml')//ROW[NAZWISKO = 'BRZEZINSKI']/ID_ZESP
return sum(
    for $pracownik in doc('file:///C:/Users/kowal/Desktop/XPath-XSLT/zesp_prac.xml')//ROW[ID_ZESP = $idZesp]
    return $pracownik/PLACA_POD)