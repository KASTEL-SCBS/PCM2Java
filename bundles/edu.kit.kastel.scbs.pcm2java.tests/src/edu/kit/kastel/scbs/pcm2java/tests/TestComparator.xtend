package edu.kit.kastel.scbs.pcm2java.tests

import java.io.IOException
import java.nio.charset.StandardCharsets
import java.nio.file.Files
import java.nio.file.Paths
import org.eclipse.internal.xtend.util.Triplet

class TestComparator {
    
    def static Iterable<String> compareMin2JavaGoldStandard(Iterable<Triplet<String, String, String>> results) {
        
    }
    
 
    def static String readFile(String path) throws IOException {
        val byte[] encoded = Files.readAllBytes(Paths.get(path));
        return new String(encoded, StandardCharsets.UTF_8.name());
    }
       
}