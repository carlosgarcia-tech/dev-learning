db.ventas.drop();
db.ventas.insertMany([
  { vendedor: "ana", importe: 120, ciudad: "madrid" },
  { vendedor: "ana", importe: 80, ciudad: "barcelona" },
  { vendedor: "luis", importe: 250, ciudad: "madrid" },
  { vendedor: "carla", importe: 300, ciudad: "valencia" },
  { vendedor: "luis", importe: 150, ciudad: "barcelona" },
  { vendedor: "ana", importe: 200, ciudad: "valencia" },
  { vendedor: "carla", importe: 90, ciudad: "madrid" },
  { vendedor: "luis", importe: 175, ciudad: "valencia" },
  { vendedor: "marta", importe: 110, ciudad: "barcelona" },
  { vendedor: "marta", importe: 65, ciudad: "madrid" }
]);
