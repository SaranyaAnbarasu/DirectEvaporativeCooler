within DirectEvaporativeCooler.Examples;
model DirectEvapCoolerPhysicsPreDrop50mm
  extends Modelica.Icons.Example;

  //Medium model
  package MediumWater = Buildings.Media.Water "Water medium";
  package MediumAir = Buildings.Media.Air "Air medium";

  parameter Modelica.SIunits.MassFlowRate mW_flow_nominal=0.256 "Nominal mass flow rate on water side";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal=0.64 "Nominal mass flow rate on air side";

  parameter Modelica.SIunits.PressureDifference dpW_nominal=100 "Nominal pressure drop on the water side";
  parameter Modelica.SIunits.PressureDifference dpA_nominal=63 "Nominal pressure drop on the air side";
  parameter Modelica.SIunits.PressureDifference dpD_nominal=10 "Nominal pressure drop across the duct";

  SystemModel.DecSystemPhysicsBased
                           decSys(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mA_flow_nominal,
    dp_nominal=dpA_nominal,
    mW_flow_nominal=mW_flow_nominal,
    dp_pad_nominal(displayUnit="Pa") = dpA_nominal,
    dp_pip_nominal(displayUnit="Pa") = dpW_nominal,
    Thickness=0.05,
    Length=0.42,
    Height=0.42,
    CooPadMaterial=DirectEvaporativeCooler.BaseClasses.CooPadMaterial.Cellulose,
    Contact_surface_area=556,
    perFan=HCT_45_2T,
    perPum=Breezair_Icon_pump)  "Direct evaporative cooling system" annotation (Placement(transformation(extent={{-30,30},{-10,50}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumAir,
    use_Xi_in=false,
    use_T_in=false,
    nPorts=1) annotation (Placement(transformation(extent={{-66,30},{-46,50}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = MediumAir,
    use_T_in=false,
    nPorts=1) annotation (Placement(transformation(extent={{100,30},{80,50}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium = MediumAir, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{30,32},{46,48}})));
  Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort senWetBul(redeclare package Medium = MediumAir, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{54,32},{70,48}})));
  Buildings.Fluid.FixedResistances.PressureDrop ducRes(
    redeclare package Medium = MediumAir,
    m_flow_nominal=mA_flow_nominal,
    dp_nominal=dpD_nominal) "Resistance offered by the duct" annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Sources.Constant
                               pumSig(k=mW_flow_nominal)
                                      "Pump signal" annotation (Placement(transformation(extent={{-92,68},{-80,80}})));
  Modelica.Blocks.Sources.TimeTable
                               fanSig(
    table=[0,108.0998278; 1,324.2994835; 2,540.4991391; 3,756.6987947; 4,972.8984504; 5,1189.098106; 6,1405.297762; 7,
        1621.497417],
    timeScale=300,
    offset=2)                         "Fan Signal" annotation (Placement(transformation(extent={{-92,-6},{-80,6}})));

  Modelica.Blocks.Sources.RealExpression PreSim(y=decSys.cooPad.dp_pad_cal)   "massflow rate of water consumed"
    annotation (Placement(transformation(extent={{144,-106},{160,-90}})));
  Modelica.Blocks.Sources.TimeTable PreData(table=[0,0.2; 1,0.683495888; 2,3.944157583; 3,7.780263913; 4,14.03977816;
        5,18.31688659; 6,23.44195831; 7,29.42665902; 8,37.54981832; 9,43.67986231; 10,50.2388602; 11,57.36813922; 12,63.49990438],
      timeScale=175)                    annotation (Placement(transformation(extent={{140,-132},{160,-112}})));
  Modelica.Blocks.Math.Add PreErr(k2=-1) "Water consumption error in the data"
    annotation (Placement(transformation(extent={{180,-120},{200,-100}})));
  Modelica.Blocks.Sources.RealExpression VelocitySim(y=decSys.cooPad.senVel.v) "Saturation efficiency"
    annotation (Placement(transformation(extent={{144,-48},{160,-32}})));
  Modelica.Blocks.Math.Add VelDatErr(k2=-1) "Efficiency error"
    annotation (Placement(transformation(extent={{180,-60},{200,-40}})));
  Modelica.Blocks.Sources.TimeTable VelocityDat(table=[0,0.225568942; 1,0.540160643; 2,0.978580991; 3,1.346720214; 4,1.805220884;
        5,1.955823293; 6,2.267068273; 7,2.53480589; 8,2.879518072; 9,3.103748327; 10,3.321285141; 11,3.558902276; 12,3.753012048],
      timeScale=175)                    annotation (Placement(transformation(extent={{140,-80},{160,-60}})));
  Modelica.Blocks.Sources.RealExpression CFM(y=(decSys.m_flow/1.225)*2118.88) "CFM through the cooler"
    annotation (Placement(transformation(extent={{144,-28},{160,-12}})));
  parameter Records.BreezairIcon170PumpCurve Breezair_Icon_pump
    annotation (Placement(transformation(extent={{-100,-136},{-80,-116}})));
  parameter Records.HCT_45_2T HCT_45_2T annotation (Placement(transformation(extent={{-12,-126},{8,-106}})));
  Modelica.Blocks.Sources.RealExpression leL(y=(1/decSys.Contact_surface_area)/decSys.Thickness)
    "CFM through the cooler" annotation (Placement(transformation(extent={{-94,-52},{-78,-36}})));
equation
  connect(sou.ports[1], decSys.port_a) annotation (Line(
      points={{-46,40},{-38,40},{-38,40},{-30,40}},
      color={0,127,255},
      thickness=0.5));
  connect(sin.ports[1], senWetBul.port_b) annotation (Line(
      points={{80,40},{76,40},{76,40},{70,40}},
      color={0,127,255},
      thickness=0.5));
  connect(senWetBul.port_a, senTem.port_b) annotation (Line(
      points={{54,40},{46,40}},
      color={0,127,255},
      thickness=0.5));
  connect(senTem.port_a, ducRes.port_b) annotation (Line(
      points={{30,40},{20,40}},
      color={0,127,255},
      thickness=0.5));
  connect(ducRes.port_a, decSys.port_b) annotation (Line(
      points={{0,40},{-10,40}},
      color={0,127,255},
      thickness=0.5));
  connect(fanSig.y, decSys.fanSig) annotation (Line(
      points={{-79.4,0},{-40,0},{-40,43},{-32,43}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(pumSig.y, decSys.pumSig) annotation (Line(
      points={{-79.4,74},{-32,74},{-32,48}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(PreSim.y, PreErr.u1)
    annotation (Line(points={{160.8,-98},{172,-98},{172,-104},{178,-104}}, color={0,0,127}));
  connect(PreData.y, PreErr.u2)
    annotation (Line(points={{161,-122},{170,-122},{170,-116},{178,-116}}, color={0,0,127}));
  connect(VelDatErr.u1, VelocitySim.y)
    annotation (Line(points={{178,-44},{168,-44},{168,-40},{160.8,-40}}, color={0,0,127}));
  connect(VelocityDat.y, VelDatErr.u2)
    annotation (Line(points={{161,-70},{168,-70},{168,-56},{178,-56}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,100}})), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -140},{220,100}})),
                          experiment(
      StopTime=41400,
      Interval=300,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
       __Dymola_Commands(file="modelica://DirectEvaporativeCooler/Scripts/DirectEvapCoolerPreDrop50mm.mos"
        "Simulate and plot"));
end DirectEvapCoolerPhysicsPreDrop50mm;
