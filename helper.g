IsFacetTransitive:=function(sc)
    local g,aut,facets;
    aut:=SCAutomorphismGroup(c);
    facets:=SCFacets(c);
    if Length(Orbit(aut, facets[1],OnSets)) =Length(facets) then 
        return true;
    else
        return false;
    fi;


end;


VertexFaceType:=function(sc)
    local autV,nv,stab,facet;
    if IsFacetTransitive(sc) then 
        autV:=SCAutomorphismGroup(sc);
        nv:=Length(Orbits(autV));
        facet:=SCFacets(c)[1];
        stab:=Stabiliser(aut,[1,2,3,4],OnSets);
        return [nv,Order(stab)];
    fi;
    return fail;
end;

