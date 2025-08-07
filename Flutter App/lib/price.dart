import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Price extends StatefulWidget {
  const Price({super.key});

  @override
  State<Price> createState() => _PriceState();
}

class _PriceState extends State<Price> {
  TextEditingController _controllerModel = TextEditingController();
  TextEditingController _controllerBattery = TextEditingController();
  TextEditingController _controllerOriginal = TextEditingController();
  String _selectedModel = "";
  int? _selectedCompany;
  int? _selectedRAM;
  int? _selectedStorage;
  int? _selectedOS;
  int? _selectedChipset;
  int? _selectedBattery;
  int? _selectedYear;
  int? _selectedCondition;
  int? _selectedPTA;
  int? _selected5G;
  int? _selectedOriginal;
  String? _price;
  bool _loading = false;

  Future<void> _predictPrice() async {
    setState(() {
      _loading = true;
    });

    final uri = Uri.parse('http://192.168.171.136/predictPrice');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "Phone Company": _selectedCompany,
        "RAM": _selectedRAM,
        "Storage": _selectedStorage,
        "Processor": _selectedChipset,
        "Battery Capacity": _selectedBattery,
        "Operating System": _selectedOS,
        "External Condition": _selectedCondition,
        "5g Support": _selected5G,
        "PTA Approved": _selectedPTA,
        "Year of Release": _selectedYear,
        "Original Price": _selectedOriginal
      }),
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      setState(() {
        _price = result['predicted_price'].toString();
      });
    } else {
      setState(() {
        _price = 'Error: ${response.reasonPhrase}';
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Price'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Phone Model",
                    border: OutlineInputBorder(),
                  ),
                  controller: _controllerModel,
                  onChanged: (value) {
                    _selectedModel = _controllerModel.text.toString();
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                DropdownMenu(
                  onSelected: (company) {
                    setState(() {
                      if (company != Null) {
                        _selectedCompany = company;
                      }
                    });
                  },
                  label: const Text("Phone Company"),
                  helperText: "Select the company of your phone.",
                  width: 300.0,
                  menuHeight: 200.0,
                  enableSearch: true,
                  dropdownMenuEntries: const <DropdownMenuEntry>[
                    DropdownMenuEntry(value: 0, label: "Apple"),
                    DropdownMenuEntry(value: 1, label: "Google"),
                    DropdownMenuEntry(value: 2, label: "Huawei"),
                    DropdownMenuEntry(value: 3, label: "Infinix"),
                    DropdownMenuEntry(value: 4, label: "LG"),
                    DropdownMenuEntry(value: 5, label: "Oneplus"),
                    DropdownMenuEntry(value: 6, label: "Oppo"),
                    DropdownMenuEntry(value: 7, label: "Poco"),
                    DropdownMenuEntry(value: 8, label: "Realme"),
                    DropdownMenuEntry(value: 9, label: "Samsung"),
                    DropdownMenuEntry(value: 10, label: "Tecno"),
                    DropdownMenuEntry(value: 11, label: "Vivo"),
                    DropdownMenuEntry(value: 12, label: "Xiaomi"),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DropdownMenu(
                      onSelected: (ram) {
                        setState(() {
                          if (ram != Null) {
                            _selectedRAM = ram;
                          }
                        });
                      },
                      label: const Text("RAM"),
                      helperText: "Select RAM",
                      width: 120.0,
                      menuHeight: 150.0,
                      enableSearch: true,
                      dropdownMenuEntries: const <DropdownMenuEntry>[
                        DropdownMenuEntry(value: 4, label: "4"),
                        DropdownMenuEntry(value: 6, label: "6"),
                        DropdownMenuEntry(value: 8, label: "8"),
                        DropdownMenuEntry(value: 10, label: "10"),
                        DropdownMenuEntry(value: 12, label: "12"),
                        DropdownMenuEntry(value: 16, label: "16"),
                      ],
                    ),
                    DropdownMenu(
                      onSelected: (storage) {
                        setState(() {
                          if (storage != Null) {
                            _selectedStorage = storage;
                          }
                        });
                      },
                      label: const Text("Internal Storage"),
                      helperText: "Select Internal Storage",
                      width: 205.0,
                      menuHeight: 150.0,
                      enableSearch: true,
                      dropdownMenuEntries: const <DropdownMenuEntry>[
                        DropdownMenuEntry(value: 32, label: "32"),
                        DropdownMenuEntry(value: 64, label: "64"),
                        DropdownMenuEntry(value: 128, label: "128"),
                        DropdownMenuEntry(value: 256, label: "256"),
                        DropdownMenuEntry(value: 512, label: "512"),
                        DropdownMenuEntry(value: 1024, label: "1024"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Operating System"),
                    Row(
                      children: [
                        Radio(
                            value: 0,
                            groupValue: _selectedOS,
                            onChanged: (value) {
                              setState(() {
                                _selectedOS = value;
                              });
                            }),
                        const Text("Android"),
                        const SizedBox(width: 20.0),
                        Radio(
                            value: 1,
                            groupValue: _selectedOS,
                            onChanged: (value) {
                              setState(() {
                                _selectedOS = value;
                              });
                            }),
                        const Text("iOS"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                DropdownMenu(
                  onSelected: (chipset) {
                    setState(() {
                      if (chipset != Null) {
                        _selectedChipset = chipset;
                      }
                    });
                  },
                  label: const Text("Chipset"),
                  helperText: "Select the chipset(Processor) of your phone.",
                  width: 300.0,
                  menuHeight: 200.0,
                  enableSearch: true,
                  dropdownMenuEntries: const <DropdownMenuEntry>[
                    DropdownMenuEntry(value: 0, label: "Apple Bionic"),
                    DropdownMenuEntry(value: 1, label: "Apple Pro"),
                    DropdownMenuEntry(value: 2, label: "Exynos"),
                    DropdownMenuEntry(value: 3, label: "Google Tensor"),
                    DropdownMenuEntry(value: 4, label: "Kirin"),
                    DropdownMenuEntry(value: 5, label: "Mediatek Dimensity"),
                    DropdownMenuEntry(value: 6, label: "Mediatek Helio"),
                    DropdownMenuEntry(value: 7, label: "Snapdragon"),
                    DropdownMenuEntry(value: 8, label: "Unisoc"),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150.0,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Battery Capacity",
                          border: OutlineInputBorder(),
                        ),
                        controller: _controllerBattery,
                        onChanged: (value) {
                          _selectedBattery =
                              int.parse(_controllerBattery.text.toString());
                        },
                      ),
                    ),
                    DropdownMenu(
                      onSelected: (year) {
                        setState(() {
                          if (year != Null) {
                            _selectedYear = year;
                          }
                        });
                      },
                      label: const Text("Launch Year"),
                      width: 180.0,
                      menuHeight: 150.0,
                      enableSearch: true,
                      dropdownMenuEntries: const <DropdownMenuEntry>[
                        DropdownMenuEntry(value: 2015, label: "2015"),
                        DropdownMenuEntry(value: 2016, label: "2016"),
                        DropdownMenuEntry(value: 2017, label: "2017"),
                        DropdownMenuEntry(value: 2018, label: "2018"),
                        DropdownMenuEntry(value: 2019, label: "2019"),
                        DropdownMenuEntry(value: 2020, label: "2020"),
                        DropdownMenuEntry(value: 2021, label: "2021"),
                        DropdownMenuEntry(value: 2022, label: "2022"),
                        DropdownMenuEntry(value: 2023, label: "2023"),
                        DropdownMenuEntry(value: 2024, label: "2024"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                DropdownMenu(
                  onSelected: (condition) {
                    setState(() {
                      if (condition != Null) {
                        _selectedCondition = condition;
                      }
                    });
                  },
                  label: const Text("External Condition"),
                  helperText: "Select the Predicted External Condition",
                  width: 250.0,
                  menuHeight: 150.0,
                  enableSearch: true,
                  dropdownMenuEntries: const <DropdownMenuEntry>[
                    DropdownMenuEntry(value: 2, label: "Good"),
                    DropdownMenuEntry(value: 1, label: "Bad"),
                    DropdownMenuEntry(value: 0, label: "Average"),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("PTA Approved"),
                    Row(
                      children: [
                        Radio(
                            value: 0,
                            groupValue: _selectedPTA,
                            onChanged: (value) {
                              setState(() {
                                _selectedPTA = value;
                              });
                            }),
                        const Text("No"),
                        const SizedBox(width: 20.0),
                        Radio(
                            value: 1,
                            groupValue: _selectedPTA,
                            onChanged: (value) {
                              setState(() {
                                _selectedPTA = value;
                              });
                            }),
                        const Text("Yes"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("5G Support"),
                    Row(
                      children: [
                        Radio(
                            value: 0,
                            groupValue: _selected5G,
                            onChanged: (value) {
                              setState(() {
                                _selected5G = value;
                              });
                            }),
                        const Text("No"),
                        const SizedBox(width: 20.0),
                        Radio(
                            value: 1,
                            groupValue: _selected5G,
                            onChanged: (value) {
                              setState(() {
                                _selected5G = value;
                              });
                            }),
                        const Text("Yes"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: 150.0,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Launch Price",
                      border: OutlineInputBorder(),
                    ),
                    controller: _controllerOriginal,
                    onChanged: (value) {
                      _selectedOriginal =
                          int.parse(_controllerOriginal.text.toString());
                    },
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Center(
                    child: ElevatedButton(
                  onPressed: () => {
                    if (_selectedModel == "" ||
                        _selectedCompany == null ||
                        _selectedRAM == null ||
                        _selectedStorage == null ||
                        _selectedOS == null ||
                        _selectedChipset == null ||
                        _selectedBattery == null ||
                        _selectedYear == null ||
                        _selectedCondition == null ||
                        _selectedPTA == null ||
                        _selected5G == null ||
                        _selectedOriginal == null)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text("Please fill all the required fields")),
                        )
                      }
                    else
                      {_predictPrice()}
                  },
                  child: const Text(
                    "Predict Price",
                    style: TextStyle(fontSize: 20.0),
                  ),
                )),
                const SizedBox(
                  height: 10.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_loading) const CircularProgressIndicator(),
                    if (_price != null)
                      Text(
                        "Approximate Price for your $_selectedModel is",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    Text(
                      "Rs.$_price",
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ));
  }
}
