package app.lucene;

import org.apache.lucene.analysis.en.EnglishAnalyzer;
import org.apache.lucene.analysis.pl.PolishAnalyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.*;
import org.apache.lucene.queryparser.classic.ParseException;
import org.apache.lucene.queryparser.classic.QueryParser;
import org.apache.lucene.search.IndexSearcher;
import org.apache.lucene.search.Query;
import org.apache.lucene.search.ScoreDoc;
import org.apache.lucene.search.TopDocs;
import org.apache.lucene.store.ByteBuffersDirectory;
import org.apache.lucene.store.Directory;
import java.io.IOException;

public class Main {
    public static void main(String[] args) throws IOException, ParseException {
        //StandardAnalyzer analyzer = new StandardAnalyzer();

        //ZADANIE 9
        //EnglishAnalyzer analyzer = new EnglishAnalyzer();
        //EnglishAnalyzer jest zoptymalizowany pod kątem języka angielskiego i wykorzystuje stopwords i stemming dla tego języka

        //ZADANIE 11
        PolishAnalyzer analyzer = new PolishAnalyzer();

        Directory directory = new ByteBuffersDirectory();

        IndexWriterConfig config = new IndexWriterConfig(analyzer);

        IndexWriter w = new IndexWriter(directory, config);

//        w.addDocument(buildDoc("Lucene in Action", "9781473671911"));
//        w.addDocument(buildDoc("Lucene for Dummies", "9780735219090"));
//        w.addDocument(buildDoc("Managing Gigabytes", "9781982131739"));
//        w.addDocument(buildDoc("The Art of Computer Science",
//                "9781250301695"));
//        w.addDocument(buildDoc("Dummy and yummy title", "9780525656161"));

        //ZADANIE 11
        w.addDocument(buildDoc("Lucyna w akcji", "9780062316097"));
        w.addDocument(buildDoc("Akcje rosną i spadają", "9780385545955"));
        w.addDocument(buildDoc("Bo ponieważ", "9781501168007"));
        w.addDocument(buildDoc("Naturalnie urodzeni mordercy", "9780316485616"));
        w.addDocument(buildDoc("Druhna rodzi", "9780593301760"));
        w.addDocument(buildDoc("Urodzić się na nowo", "9780679777489"));

        w.close();

        //ZADANIE 6
        //String querystr = "*:*";

        //ZADANIE 7 a)
        //String querystr = "title:dummy";

        //ZADANIE 7 b)
        //String querystr = "title:and";

        //ZADANIE 12 a)
        //String querystr = "isbn:9780062316097";

        //ZADANIE 12 b)
        //String querystr = "title:urodzić";

        //ZADANIE 12 c)
        //String querystr = "title:rodzić";

        //ZADANIE 12 d)
        //String querystr = "title:ro*";

        //ZADANIE 12 e)
        //String querystr = "title:ponieważ";

        //ZADANIE 12 f)
        //String querystr = "title:Lucyna AND title:akcja";

        //ZADANIE 12 g)
        //String querystr = "title:akcja -Lucyna";

        //ZADANIE 12 h)
        //String querystr = "title:\"naturalnie morderca\"~2";

        //ZADANIE 12 i)
        //String querystr = "title:\"naturalnie morderca\"~1";

        //ZADANIE 12 j)
        //String querystr = "title:\"naturalnie morderca\"~0";

        //ZADANIE 12 k)
        //String querystr = "title:naturalne";

        //ZADANIE 12 l)
        String querystr = "title:naturalne~";

        Query q = new QueryParser("title", analyzer).parse(querystr);

        int maxHits = 10;
        IndexReader reader = DirectoryReader.open(directory);
        IndexSearcher searcher = new IndexSearcher(reader);
        TopDocs docs = searcher.search(q, maxHits);
        ScoreDoc[] hits = docs.scoreDocs;

        System.out.println("Found " + hits.length + " matching docs.");
        StoredFields storedFields = searcher.storedFields();
        for(int i=0; i<hits.length; ++i) {
            int docId = hits[i].doc;
            Document d = storedFields.document(docId);
            System.out.println((i + 1) + ". " + d.get("isbn")
                    + "\t" + d.get("title"));
        }
        reader.close();
    }
    private static Document buildDoc(String title, String isbn) {
        Document doc = new Document();
        doc.add(new TextField("title", title, Field.Store.YES));
        doc.add(new StringField("isbn", isbn, Field.Store.YES));
        return doc;
    }
}
