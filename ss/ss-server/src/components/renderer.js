
let currentCodeFlower;
var createCodeFlower = function(json) {
  // update the jsonData textarea
  document.getElementById('jsonData').value = JSON.stringify(json, null, 2);

  // Let's format the sniffed wireless json into a proper 'CodeFlower' format
  // let jsonStringified = JSON.stringify(json);

  console.log("#json = ", json);

  // Only format our own data
  if (json !== null) {
    if ("mac" in json) {

      // console.log("json = ", json);

      let formattedJson = {};
      formattedJson["name"] = json["mac"];
      formattedJson["size"] = 10;

      let sniffedValues = json["values"];
      // let formattedSniffedValues = { children: []};
      let formattedSniffedValues = [];

      for (let index = 0; index < sniffedValues.length; index++) {
        const ap = sniffedValues[index];
        // console.log("ap = ", ap, "siglev = ", parseInt(ap["signal_level"]) );
        let formattedAp = {
          name: ap["ssid"],
          size: parseInt(ap["signal_level"]) * -1,
          language: "javascript"
        };
        formattedSniffedValues.push(formattedAp);
      }

      formattedJson["children"] = formattedSniffedValues;

      console.log("formattedJson = ", formattedJson);

      json = formattedJson;
    }
  }

  // remove previous flower to save memory
  if (currentCodeFlower) currentCodeFlower.cleanup();
  // adapt layout size to the total number of elements
  var total = countElements(json);
  // w = parseInt(Math.sqrt(total) * 30, 10);
  // h = parseInt(Math.sqrt(total) * 30, 10);

  // console.log(w, h);

  w = 600;
  h = 600;

  // create a new CodeFlower
  currentCodeFlower = new CodeFlower("#visualization", w, h).update(json);
};

d3.json('data.json', createCodeFlower);

document.getElementById('project').addEventListener('change', function() {
  d3.json(this.value, createCodeFlower);
});
document.getElementById('jsonInput').addEventListener('submit', function(e) {
  e.preventDefault();
  document.getElementById('visualization').scrollIntoView();
  var json = JSON.parse(document.getElementById('jsonData').value);
  currentCodeFlower.update(json);
});