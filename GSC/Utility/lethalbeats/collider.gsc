/*
///DocStringBegin
detail: pointInCylinder(point: <Vector3>, cylCenter: <Vector3>, radius: <Float>, height: <Float>): <Bool>
summary: Returns true if the point lies inside or on the surface of the vertical cylinder centered at cylCenter, with given radius (XY) and height (Z, half up/down).
///DocStringEnd
*/
pointInCylinder(point, cylPos, radius, height)
{
	// Check horizontal distance (XY plane)
	dx = point[0] - cylPos[0];
	dy = point[1] - cylPos[1];
	if ((dx*dx + dy*dy) > (radius * radius)) return false;

	// Check vertical (Z)
	if (abs(point[2] - cylPos[2]) > height) return false;

	return true;
}
/*
///DocStringBegin
detail: raySphereIntersect(start: <Vector3>, end: <Vector3>, spherePos: <Vector3>, radius: <Float>): <Bool>
summary: Pezbot's line sphere intersection: http://paulbourke.net/geometry/circlesphere/raysphere.c
///DocStringEnd
*/
raySphereIntersect(start, end, spherePos, radius)
{
	// check if the start or end points are in the sphere
	r2 = radius * radius;
	
	if (distancesquared(start, spherePos) < r2)
	{
		return true;
	}
	
	if (distancesquared(end, spherePos) < r2)
	{
		return true;
	}
	
	// check if the line made by start and end intersect the sphere
	dp = end - start;
	a = dp[ 0 ] * dp[ 0 ] + dp[ 1 ] * dp[ 1 ] + dp[ 2 ] * dp[ 2 ];
	b = 2 * (dp[ 0 ] * (start[ 0 ] - spherePos[ 0 ]) + dp[ 1 ] * (start[ 1 ] - spherePos[ 1 ]) + dp[ 2 ] * (start[ 2 ] - spherePos[ 2 ]));
	c = spherePos[ 0 ] * spherePos[ 0 ] + spherePos[ 1 ] * spherePos[ 1 ] + spherePos[ 2 ] * spherePos[ 2 ];
	c += start[ 0 ] * start[ 0 ] + start[ 1 ] * start[ 1 ] + start[ 2 ] * start[ 2 ];
	c -= 2.0 * (spherePos[ 0 ] * start[ 0 ] + spherePos[ 1 ] * start[ 1 ] + spherePos[ 2 ] * start[ 2 ]);
	c -= radius * radius;
	bb4ac = b * b - 4.0 * a * c;
	
	if (abs(a) < 0.0001 || bb4ac < 0)
	{
		return false;
	}
	
	mu1 = (0 - b + sqrt(bb4ac)) / (2 * a);
	// mu2 = (0-b - sqrt(bb4ac)) / (2 * a);
	
	// intersection points of the sphere
	ip1 = start + mu1 * dp;
	// ip2 = start + mu2 * dp;
	
	myDist = distancesquared(start, end);
	
	// check if both intersection points far
	if (distancesquared(start, ip1) > myDist/* && distancesquared(start, ip2) > myDist*/)
	{
		return false;
	}
	
	dpAngles = vectortoangles(dp);
	
	// check if the point is behind us
	if (lethalbeats\vector::vector_get_cone_dot(ip1, start, dpAngles) < 0/* || getConeDot(ip2, start, dpAngles) < 0*/)
	{
		return false;
	}
	
	return true;
}

/*
///DocStringBegin
detail: pointInSphere(point: <Vector3>, spherePos: <Vector3>, radius: <Float>): <Bool>
summary: Returns true if the point lies inside or on the surface of the sphere centered at spherePos with given radius.
///DocStringEnd
*/
pointInSphere(point, spherePos, radius)
{
	// Negative radius treated as zero-radius sphere.
	if (radius <= 0)
	{
		return point[0] == spherePos[0] && point[1] == spherePos[1] && point[2] == spherePos[2];
	}

	r2 = radius * radius;
	return distancesquared(point, spherePos) <= r2; // inclusive: on the surface counts as inside
}

/*
///DocStringBegin
detail: pointInBox(point: <Vector3>, center: <Vector3>, size: <Vector3>, angles: <Vector3>): <Bool>
summary: Returns true if the point lies inside or on the surface of the oriented box defined by center, size (full extents), and angles.
///DocStringEnd
*/
pointInBox(point, center, size, angles)
{
	// Derive orthonormal basis from angles (same as rayBoxIntersect)
	fwd = anglesToForward(angles);
	right = anglesToRight(angles);
	up = anglesToUp(angles);

	// Convert world point to box local coordinates (center = origin)
	local = lethalbeats\vector::vector_world_to_local(point, center, fwd, right, up);

	half = (size[0] * 0.5, size[1] * 0.5, size[2] * 0.5);

	// Handle degenerate (zero or negative) sizes: treat negative like zero thickness plane on that axis
	for (i = 0; i < 3; i++)
	{
		if (half[i] < 0)
		{
			half[i] = 0; // clamp
		}
	}

	// Inclusive check (on boundary counts inside). Small epsilon for float error.
	eps = 0.0001;
	if (local[0] < -half[0] - eps || local[0] > half[0] + eps) return false;
	if (local[1] < -half[1] - eps || local[1] > half[1] + eps) return false;
	if (local[2] < -half[2] - eps || local[2] > half[2] + eps) return false;

	return true;
}

/*
///DocStringBegin
detail: rayBoxIntersect(start: <Vector3>, end: <Vector3>, center: <Vector3>, size: <Vector3>, angles: <Vector3>): <Bool>
summary: 
///DocStringEnd
*/
rayBoxIntersect(start, end, center, size, angles)
{
	// Get orthogonal axes from the angles.
	fwd = anglesToForward(angles);
	right = anglesToRight(angles);
	up = anglesToUp(angles);

	half = (size[0] * 0.5, size[1] * 0.5, size[2] * 0.5);
	localMin = (-half[0], -half[1], -half[2]);
	localMax = ( half[0],  half[1],  half[2]);

	localStart = lethalbeats\vector::vector_world_to_local(start, center, fwd, right, up);
	localEnd   = lethalbeats\vector::vector_world_to_local(end,   center, fwd, right, up);

	return _rayBoxIntersect(localStart, localEnd, localMin, localMax);
}

// Ray-box intersection
_rayBoxIntersect(start, end, boxMin, boxMax)
{
	// Intersection of a segment (start->end) with an AABB (boxMin/boxMax)
	// "Slabs" method. Returns true if the segment crosses or touches the box.
	dir = end - start;

	// If the starting point is already inside the box, return true quickly
	if (start[0] >= boxMin[0] && start[0] <= boxMax[0]
		&& start[1] >= boxMin[1] && start[1] <= boxMax[1]
		&& start[2] >= boxMin[2] && start[2] <= boxMax[2])
	{
		return true;
	}

	tmin = 0; // minimum parameter along the segment (0 = start)
	tmax = 1; // maximum parameter (1 = end)

	for (i = 0; i < 3; i++)
	{
		if (abs(dir[i]) < 0.0001)
		{
			// Segment parallel to the plane of this axis: must be within the range
			if (start[i] < boxMin[i] || start[i] > boxMax[i]) return false;
			continue;
		}

		invD = 1.0 / dir[i];
		t1 = (boxMin[i] - start[i]) * invD;
		t2 = (boxMax[i] - start[i]) * invD;

		 // Ensure t1 <= t2
		if (t1 > t2)
		{
			tmp = t1;
			t1 = t2;
			t2 = tmp;
		}

		// Restrict the interval [tmin, tmax]
		if (t1 > tmin) tmin = t1;
		if (t2 < tmax) tmax = t2;

		// If the interval is inverted, there is no intersection
		if (tmin > tmax) return false;
	}

	// Check that the intersection falls within the segment (0..1)
	if (tmax < 0 || tmin > 1) return false;

	return true;
}

/*
///DocStringBegin
detail: pointInCone(point: <Vector3>, apex: <Vector3>, angles: <Vector3>, halfAngleDeg: <Float>, maxDistance: <Float>): <Bool>
summary: Returns true si el punto está dentro (o en la superficie) de un cono finito con vértice en apex, eje definido por angles, ángulo medio halfAngleDeg y longitud maxDistance.
///DocStringEnd
*/
pointInCone(point, apex, angles, halfAngleDeg, maxDistance)
{
	if (!isDefined(maxDistance)) maxDistance = 0; // without limit

	v = point - apex;
	dist2 = v[0]*v[0] + v[1]*v[1] + v[2]*v[2];

	if (maxDistance > 0 && dist2 > maxDistance * maxDistance) 
		return false;

	// Punto en el vértice (dentro siempre).
	if (dist2 <= 0.000001)
		return true;

	forward = anglesToForward(angles);

	vNorm = vectorNormalize(v);
	d = vectorDot(vNorm, forward);

	// Si está detrás del eje (d < 0) no está dentro (a menos que el cono sea 180, ya acotado).
	if (d < 0) return false;

	// Normaliza y acota el halfAngle para evitar casos patológicos.
	if (halfAngleDeg < 0) halfAngleDeg = 0;
	if (halfAngleDeg > 179.999) halfAngleDeg = 179.999; // evita cos(180) = -1 exacto

	// Cono degenerado (halfAngleDeg == 0): sólo acepta puntos prácticamente alineados con el eje.
	if (halfAngleDeg == 0)
	{
		// d ~ 1 implica alineación; tolerancia pequeña para errores float.
		return d >= 0.9999;
	}

	// Inclusivo: en el borde cuenta.
	if (d >= cos(halfAngleDeg)) return true;

	return false;
}
