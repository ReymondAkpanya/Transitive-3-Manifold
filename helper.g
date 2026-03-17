IsFacetTransitive:=function(c)
    local g,aut,facets;
    aut:=SCAutomorphismGroup(c);
    facets:=SCFacets(c);
    if Length(Orbit(aut, facets[1],OnSets)) =Length(facets) then 
        return true;
    else
        return false;
    fi;
end;


VertexFaceType:=function(c)
    local autV,nv,stab,facet;
    if IsFacetTransitive(c) then 
        autV:=SCAutomorphismGroup(c);
        nv:=Length(Orbits(autV));
        facet:=SCFacets(c)[1];
        stab:=Stabiliser(autV,facet,OnSets);
        return [nv,Order(stab),StructureDescription(stab)];
    fi;
    return fail;
end;

IsCubicCover:=function(gamma, G, cubicgraphs)
    local g,edges,orb,orbs,e,temp,p,gamma2,n,facets,inters,i,j;
    edges:=DigraphEdges(gamma);
    edges:=Set(List(edges,Set));
    orbs:=Orbits(G,edges,OnSets);
    for orb in orbs do 
        e:=orb[1];
        temp:=Filtered(cubicgraphs,C-> e in C);
        if Length(temp) <> 3 then 
            return false;
        fi;
        for p in [[1,2],[1,3],[2,3]] do
            inters:=Intersection(temp[p[1]],temp[p[2]]);
            gamma2:=DigraphByEdges(inters);
            if not IsConnectedDigraph(gamma) or Set(OutDegrees(gamma2)) <> [2] then 
                return false;
            fi;
        od;
    od;
    n:=DigraphNrVertices(gamma);
    facets:=List([1 .. n], i-> Filtered([1 .. Length(cubicgraphs)], j-> i in Union(cubicgraphs[j])));
    return SCFromFacets(facets) <> fail;
end;

IsSimplicialCubicCover:=function(gamma, G, cubicgraphs)
    local g,edges,orbs,orb,temp,p,gama2,n,e,sc,inters,gamma2,i,j,facets;
    edges:=DigraphEdges(gamma);
    edges:=Set(List(edges,Set));
    orbs:=Orbits(G,edges,OnSets);
    for orb in orbs do 
        e:=orb[1];
        temp:=Filtered(cubicgraphs,C-> e in C);
        if Length(temp) <> 3 then 
            return false;
        fi;
        for p in [[1,2],[1,3],[2,3]] do
            inters:=Intersection(temp[p[1]],temp[p[2]]);
            gamma2:=DigraphByEdges(inters);
            if not IsConnectedDigraph(gamma) or Set(OutDegrees(gamma2)) <> [2] then 
                return false;
            fi;
        od;
    od;
    n:=DigraphNrVertices(gamma);
    facets:=List([1 .. n], i-> Filtered([1 .. Length(cubicgraphs)], j-> i in Union(cubicgraphs[j])));
    sc:=SCFromFacets(facets);
    return SCFromFacets(facets) <> fail;
end;

SCFromCubicCover:=function(gamma, edgesRep, cubicgraphs)
    local g,edges,orbs,orb,e,temp,n,i,gamma2,inters,p,facets;
    for e in edgesRep do 
        temp:=Filtered(cubicgraphs,C-> e in C);
        if Length(temp) <> 3 then
Error(" ");
            return false;
        fi;
        for p in [[1,2],[1,3],[2,3]] do
            inters:=Intersection(temp[p[1]],temp[p[2]]);
            v:=Union(inters);
            inters:=List(inters,g->List(g,i-> Position(v,i)));
            gamma2:=DigraphByEdges(inters);
            gamma2:=DigraphSymmetricClosure(gamma2);
            if not IsSubset([0,2],Set(OutDegrees(gamma2))) and IsConnectedDigraph(gamma2) then
                Print("here ist es kaputt gegangen \n"); Error(" "); 
                return fail;
            fi;
        od;
    od;
    n:=DigraphNrVertices(gamma);
    facets:=List([1 .. n], i-> Filtered([1 .. Length(cubicgraphs)], j-> i in Union(cubicgraphs[j])));
Error("hello");
    return SCFromFacets(facets);
end;


SCFacePairingGraph:=function(sc)
    local g,edges,tempE,t,i,j,tempF,nF,nE;
    tempE:=SCFaces(sc,2);
    tempF:=SCFacets(sc);
    nF:=Length(tempF);
    nE:=Length(tempE);
    edges:=[];
    for i in [1 .. nE] do
        t:=Filtered([1.. nF], j -> IsSubset(tempF[j], tempE[i]) );
        Append(edges,[t,t{[2,1]}]);
    od; 
    return DigraphByEdges(edges);
end;





ComputeCandidates:=function(G,boolPrint)  
    local g,n,res,classes,temp,i,H,class,t,maxsubgroups;
    n:=NrMovedPoints(G);
    res:=[];
    class:=ConjugacyClassSubgroups(G,G);
    if  24 mod (Order(G)/n) = 0 then
        Add(res,class);
    fi;
    classes:=[class];
    while classes <> [] do
        if boolPrint then 
            Print("classes ", Length(classes),"\n");
        fi;
        temp:=[];
        for class in classes do 
            if boolPrint then 
                Print(Position(classes,class)," \n");
            fi;
            g:=Representative(class);
            maxsubgroups:=List(ConjugacyClassesMaximalSubgroups(g),i->Representative(i));
            for H in maxsubgroups do
                if Length(Orbits(H,[1..n]))=1 then
                    t:=[ConjugacyClassSubgroups(G,H)]; 
                    temp:=Union(temp,t);
                    if 24 mod (Order(G)/n) = 0 then
	                    res:=Union(res,t);
                        if boolPrint then 
	                        Print("found ",Length(res),"\n");
                        fi;
                    fi;
                fi;
            od;
        od;
        classes:=temp;
    od;
    return List(res,g->Representative(g));
end;


ComputeCandidatesWithCertainOrder:=function(G,ord,boolPrint)  
    local g,n,res,classes,temp,i,H,class,t,maxsubgroups,conj;
    n:=NrMovedPoints(G);
    res:=[];
    conj:=ConjugacyClassSubgroups(G,G);
    if  Order(G) = ord then
        Add(res,conj);
    fi;
    classes:=[conj];
    while classes <> [] do
        if boolPrint then 
            Print("classes ", Length(classes),"\n");
        fi;
        temp:=[];
        for class in classes do 
        Print("here\n");
            if boolPrint then 
                Print(Position(classes,class)," \n");
            fi;
            g:=Representative(class);
            maxsubgroups:=List(ConjugacyClassesMaximalSubgroups(g),i->Representative(i));
            for H in maxsubgroups do
            Print("here2 \n");
                if Length(Orbits(H,[1..n]))=1 then
                    t:=[ConjugacyClassSubgroups(G,H)]; 
                    temp:=Union(temp,t);
                    if Order(H) = ord then
	                    res:=Union(res,t);
                        if boolPrint then 
	                        Print("found ",Length(res),"\n");
                        fi;
                    fi;
                fi;
            od;
        od;
        classes:=temp;
    od;
    return List(res,g->Representative(g));
end;



ReadCayley:=function(n)
    local path,content,f,output,str_n;
    content:="/Users/reymondakpanya/Desktop/github_repos/Transitive-3-Manifold/TetraCay/Cay4val_";
    content:=Concatenation(content,String(n));
    content:=Concatenation(content, ".s6");
    return ReadDigraphs(content);
end;


AllCandidates:=function(G)
    local path, magma, input, res, output,temp; 
    if SymSurf_Magma=true then 
        path := DirectoriesSystemPrograms();
        magma := Filename( path, "magma" );
        input := InputTextString(Concatenation(
        ["load \"/home/data/akpanya/faceTransitiveSurfaces/implementationMagma.m\";\n",
                ReplacedString(ReplacedString(ConvertToMagmaInputString(G, "G"), "()", ""), ",\n,", ""),
                "M := AllCandidatesOfAutomorphismGroups_MagmaCT(G);\n",
                "print([\"Group(\"*Sprint([x : x in Generators(m)])*\")\" : m in M]);"
            ]));
        res := "";
        output := OutputTextString(res, true);
        SetPrintFormattingStatus(output,false);
        Process(path[1], magma, input, output, ["-b"]);
        res:=SplitString(res,"\n");
        res:=Concatenation(res{[2..Length(res)]});
        # edge case: trivial group constructor
        res := ReplacedString(res, "[]", "()");
        temp:=EvalString(res);
        if IsList(temp) then
            if Set(List(temp,g->IsGroup(g)))=[true] then
                return temp;
            fi;
        fi;
        return [];

    else 
        return AllCandidatesOfAutomorphismGroups_GAP(G);### TODO this function contains errors and still havent fixed them
    fi;
end;
