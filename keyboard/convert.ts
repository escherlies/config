import fs from 'fs';
import nyquist_4 from "./enryco_nyquist_rev3_4.json";
import nyquist_5 from "./enryco_nyquist_rev3_5.json";


const fill = Array(12).fill("KC_NO");

const fromNyquist4 = () => {
  const path = "./enryco_nyquist_rev3_5.json";
  const result = { ...nyquist_4 }

  result["layout"] = "LAYOUT_ortho_5x12"

  result.layers.forEach((layer, index) => {
    const firstRow = nyquist_5.layers[index].slice(0, 12)
    result.layers[index] = [...firstRow, ...layer];
  });

  fs.writeFileSync(path, JSON.stringify(result, null, 2));
}


const fromNyquist5 = () => {
  const path = "./enryco_nyquist_rev3_4.json";
  const result = { ...nyquist_5 }

  result["layout"] = "LAYOUT_ortho_4x12"

  result.layers.forEach((layer, index) => {
    result.layers[index] = layer.splice(12);
  });

  fs.writeFileSync(path, JSON.stringify(result, null, 2));
}


(() => {
  const dir = process.argv[2]
  switch (dir) {
    case "from4":
      return fromNyquist4()
    case "from5":
      return fromNyquist5()
  }
})()
