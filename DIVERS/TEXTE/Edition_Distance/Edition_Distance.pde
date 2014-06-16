

int LevenshteinDistance(char[] s, char[] t)
{
  int m = s.length;
  int n = t.length;
  
  // for all i and j, d[i,j] will hold the Levenshtein distance between
  // the first i characters of s and the first j characters of t;
  // note that d has (m+1)*(n+1) values
  int[][] d = new int[n+1][m+1];
 
  // source prefixes can be transformed into empty string by
  // dropping all characters
  for(int i=1; i<m+1; ++i)
    {
      d[0][i] = i;
    }
 
  // target prefixes can be reached from empty source prefix
  // by inserting every characters
  for(int j=1; j<n+1; ++j)
    {
      d[j][0] = j;
    }
 
  for(int j=1; j<n+1; ++j) for(int i=1; i<m+1; ++i)
    {
      if (s[i-1] == t[j-1])  //going on the assumption that string indexes are 1-based in your chosen language<!-- not: s[i-1] = t[j-1] -->
        {                   //else you will have to use s[i-1] = t[j-1] Not doing this might throw an IndexOutOfBound error
          d[j][i] = d[j-1][i-1];     // no operation required
        }
      else
        {
          d[j][i] = min(
                       d[j][i-1] + 1,  // a deletion
                       min(
                         d[j-1][i] + 1,  // an insertion
                         d[j-1][i-1] + 1 // a substitution
                          ) 
                        );
        }
    }
    
  return d[n][m];
}


void setup(){
 String[] str = new String[]{"J'aime les frites", "J'aime les filles", "J'aime pas les frites", "Mon oncle Charles aime bien les filles à poil"}; 
 for (int i=0; i<str.length; ++i) for (int j=0; j<i; ++j){
   String s_s = str[i];
   String s_t = str[j];
   char[] s = s_s.toCharArray(); 
   char[] t = s_t.toCharArray();
   int dist = LevenshteinDistance( s, t );
   println(dist+" | "+s_s+" | "+s_t);
 }
  
}
