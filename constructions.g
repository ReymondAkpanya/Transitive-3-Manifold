LoadPackage("simpcomp");
LoadPackage("digraphs");
Read("helper.g");


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




__help_ConstructFacetTransitiveManifold_4_1:=function(gamma,edges,G,orbs,n)
    local cubicCover,i,g,s,comps,temp,gamma2,sc;
    cubicCover:=[];
    if Length(orbs)=4 then
        temp:=List([1,2,3,4],i->DigraphByEdges(Difference(edges,orbs[i])));
        temp:=List(temp,DigraphSymmetricClosure);
        comp:=List(temp,g->DigraphConnectedComponents(g).comps);
        comps:=Union(comp);
        if Sum(List(comp,Length)) = Length(comps) then 
            for i in [1,2,3,4] do
                d:=temp[i];
                for t in comp[i] do
                    Add(cubicCover,Filtered(DigraphEdges(d),e->IsSubset(t,e)));
                od;
            od;
            sc:=SCFromCubicCover(gamma, List([1,2,3,4],i->orbs[i][1]),cubicCover);
            if sc <> fail then
                return [sc];
            fi;
        fi;
    fi;
    return [];
end;



ConstructFacetTransitiveManifold_4_1:=function(gamma)
    local n,edges,g,G,subgroups,orbs,res,H;
    n:=DigraphNrVertices(gamma);
    edges:=DigraphEdges(gamma);
    edges:=Set(List(edges,g->Set(g)));
    res:=[];
    G:=AutomorphismGroup(gamma);
    subgroups:=ComputeCandidatesWithCertainOrder(G,n,true);
    Print("found ", Length(subgroups), " subgroups\n");
    for H in subgroups do  
        orbs:=Orbits(H,edges,OnSets);
        Append(res,__help_ConstructFacetTransitiveManifold_4_1(gamma,edges,H,orbs,n));
    od;
    return res; # TODO up to isomorphism 
end;




BaryCentric:=function(c)
    local g,n,facets,f,res,i,j;
    facets:=SCFacets(c);
    res:=[];
    n:=Maximum(Union(facets));
    for i in [1 .. Length(facets)] do
        f:=facets[i];
        for j in f do 
	    Add(res, Union([n+i],Difference(f,[j])));
        od;
    od;
    return SCFromFacets(res);
end;



__help_ConstructFacetTransitiveManifold_1_12:=function(gamma,edges,G,orbs,n)
    local cubicCover,i,g,s,comps,temp,gamma2,sc,h1,H1,h2,H2,stab,orb,e;
    cubicCover:=[];
    if Length(orbs)=1 then
        e:=edges[1];
        stab:=Stabiliser(G,e[1]);
        H1:=Filtered(stab,g->Order(g)=3);
        H2:=Filtered(Stabiliser(G,e,OnSets),g->Order(g)=2);
        for h1 in H1 do
            for h2 in H2 do
		orb:=Orbit(Group([h1,h2]),e,OnTuples);
                if Set(OutDegrees(DigraphByEdges(orb))) =[3] then
                    orb:=Set(List(orb,Set));
                    cubicCover:=Orbit(G,orb,OnSetsSets);
                    sc:=SCFromCubicCover(gamma, Filtered(edges,g->e[1]= g[1]),cubicCover);
                    if sc <> fail then
                        return [sc];
                    fi;
                fi;
            od;
        od;
    fi;
    return [];
end;


ConstructFacetTransitiveManifold_1_12:=function(gamma)
    local n,edges,g,G,subgroups,orbs,res,H;
    n:=12*DigraphNrVertices(gamma);
    edges:=DigraphEdges(gamma);
    edges:=Set(List(edges,g->Set(g)));
    res:=[];
    G:=AutomorphismGroup(gamma);
    subgroups:=ComputeCandidatesWithCertainOrder(G,n,true);
    Print("found ", Length(subgroups), " subgroups\n");
    for H in subgroups do
        orbs:=Orbits(H,edges,OnSets);
        Append(res,__help_ConstructFacetTransitiveManifold_1_12(gamma,edges,H,orbs,n));
    od;
    return res; 
end;
        







__help_ConstructFacetTransitiveManifold_1_24:=function(gamma,edges,G,orbs,n)
    local cubicCover,i,g,s,comps,temp,gamma2,sc,h1,H1,h2,H2,stab,orb,e;
    cubicCover:=[];
    if Length(orbs)=1 then
        e:=edges[1];   
        stab:=Stabiliser(G,e[1]);
        H1:=Filtered(stab,g->Order(g)=3);
        H2:=Filtered(Stabiliser(G,e,OnSets),g->Order(g)=2);
        for h1 in H1 do
            for h2 in H2 do
                orb:=Orbit(Group([h1,h2]),e,OnTuples);
                if Set(OutDegrees(DigraphByEdges(orb))) =[3] then
                    orb:=Set(List(orb,Set));
                    cubicCover:=Orbit(G,orb,OnSetsSets);
                    sc:=SCFromCubicCover(gamma, Filtered(edges,g->e[1]= g[1]),cubicCover);
                    if sc <> fail then
                        return [sc];
                    fi;
                fi;
            od;
        od;
    fi;
    return [];
end;



ConstructFacetTransitiveManifold_1_24:=function(gamma)
    local n,edges,g,G,subgroups,orbs,res,H;
    n:=24*DigraphNrVertices(gamma); 
    edges:=DigraphEdges(gamma);
    edges:=Set(List(edges,g->Set(g)));
    res:=[];   
    G:=AutomorphismGroup(gamma);
    subgroups:=ComputeCandidatesWithCertainOrder(G,n,true);
    Print("found ", Length(subgroups), " subgroups\n");
    for H in subgroups do
        orbs:=Orbits(H,edges,OnSets);
        Append(res,__help_ConstructFacetTransitiveManifold_1_24(gamma,edges,H,orbs,n));
    od;
    return res;
end;
