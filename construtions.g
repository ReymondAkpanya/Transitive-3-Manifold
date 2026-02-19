LoadPackage("simpcomp");


ReadLutzData:= function()
    local file,line,filename,res,temp,t;
    filename:="Lutz.txt";
    res:=[];
    file := InputTextFile(filename);
    if file = fail then
        Error("Cannot open file.");
    fi;
    
    while not IsEndOfStream(file) do
        line := ReadLine(file);
        temp:="";
        if line <> fail then 
            if PositionSublist(line, "m") <> fail then 
                t:=SplitString(line,"=")[2];
                t:=SplitString(t,"\n")[1];
                temp:=Concatenation(temp,t);
                while PositionSublist(line, "]]") = fail do 
                    line := ReadLine(file);
                    temp:=Concatenation(temp,SplitString(line,"\n")[1]);
                od;
                Add(res,EvalString(temp));
            fi;
        fi;
    od;
    
    CloseStream(file);
    return res;
end;




#__help_ConstructFacetTransitiveManifold_4_1:=function(digraph,edges,group,orbits,n)
#    local colours,coloured_subgraphs,umb,g,s;
#    temp:=Filtered(Sym(4),g->Order(g) =4);
 
#    if Length(orbits)=4 then 
#        colours:=List([1,2,3,4],i->Product(List(orbits[1],g->CycleFromList(g))));
#        for i in [1,2,3,4] do
#

#        od;
#            grCycles:=findCycles(red,green);
#            bgCycles:=findCycles(blue,green);
#            umb:=List(Union(brCycles[2],grCycles[2],bgCycles[2]),g->CycleFromList(g));
#            s:=__SimplicialSurfaceByUmbrellaDescriptor(umb,n);
#            if s <>fail then 
#                return [s];
#            else
#                return [];
#            fi;
#        else
#            return [];
#        fi;
#end;



#ConstructFacetTransitiveManifold_4_1:=function(digraph)
#    local n,edges,g,G,groups,group,orbits,res;
#    n:=DigraphNrVertices(digraph);
#    edges:=DigraphEdges(digraph);
#    edges:=Set(List(edges,g->Set(g)));
#    res:=[];
#    G:=AutomorphismGroup(digraph);
#    groups:=SymSurf_AllCandidatesFiltered(G,n);
#    for group in groups do  
#        orbits:=Orbits(group,edges,OnSets);
#        Append(res,__help_ConstructFacetTransitiveManifold_4_1(digraph,edges,group,orbits,n));
#    od;
#    return IsomorphismRepresentatives(res);
#end;


