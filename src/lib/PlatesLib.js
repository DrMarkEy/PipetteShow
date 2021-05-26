let plates = {
  "MWP 24": {
    wells: 24,
    name: "MWP 24",

    dimensions: {
      cols: 6,
      rows: 4,
      width: 127.4,
      height: 85,
      radius: 16,
      marginLeft: 5.5,
      marginTop: 3,
    },
  },

  "MWP 96": {
    wells: 96,
    name: "MWP 96",

    dimensions: {
      cols: 12,
      rows: 8,
      width: 127.4,
      height: 85,
      radius: 7,
      marginLeft: 7,
      marginTop: 4,
    },
  },

  "MWP 384": {
    wells: 384,
    name: "MWP 384",

    dimensions: {
      cols: 24,
      rows: 16,
      width: 127.4,
      height: 85,
      radius: 4,
      marginLeft: 10,
      marginTop: 7,
    },
  },
};

function getWellName(plate, wellId) {
  let col = wellId % plate.dimensions.cols;
  let row = wellId / plate.dimensions.cols;

  return String.fromCharCode(65 + row) + (col + 1);
}

//Finds the smallest plate with at least numberOfWells wells
function findPlate(numberOfWells) {
  if(numberOfWells <= 24)
    return plates["MWP 24"];

  else if(numberOfWells <= 96)
    return plates["MWP 96"];

  if(numberOfWells <= 384)
    return plates["MWP 384"];

  return undefined;
}
export { getWellName, findPlate };
export default plates;
