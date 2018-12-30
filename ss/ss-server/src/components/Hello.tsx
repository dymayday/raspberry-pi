import * as React from "react";
import { checkPropTypes } from "prop-types";

export interface HelloProps { compiler: string; framework: string; };

export const Hello = (props: HelloProps) =>
    <h2>Sniffer Visualizer!</h2>;
    // <h1> Hello from {props.compiler} and {props.framework}!</h1>;

