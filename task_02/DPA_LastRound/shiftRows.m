% (C) Ing. Jiri Bucek

function [s] = tracesInput(rows)

s = rows;
rows(2,1) = s(2,2); 
rows(2,2) = s(2,3); 
rows(2,3) = s(2,4); 
rows(2,4) = s(2,1); 

rows(3,1) = s(3,3); 
rows(3,2) = s(3,4); 
rows(3,3) = s(3,1); 
rows(3,4) = s(3,2); 

rows(4,1) = s(4,4); 
rows(4,2) = s(4,1); 
rows(4,3) = s(4,2); 
rows(4,4) = s(4,3); 

