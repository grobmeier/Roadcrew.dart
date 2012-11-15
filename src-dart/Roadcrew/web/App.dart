/*
 *  Copyright 2012 Christian Grobmeier
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing,
 *  software distributed under the License is distributed
 *  on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND,
 *  either express or implied. See the License for the specific
 *  language governing permissions and limitations under the License.
 */
library RoadcrewDemo;

import 'dart:html';
import 'Roadcrew.dart';

void main() {
  RoadcrewController Roadcrew = new RoadcrewController();

  query('#myform').on.submit.add((e) {
    e.preventDefault();
    Roadcrew.goto('#tablePage');
  });

  Roadcrew.intercept('#tablePage', new RoadcrewInterceptor(_(dispatcher) {
    Roadcrew.flipToUrl('#loadingPage');
    window.setTimeout(dispatcher, 1500);
  }));

  Roadcrew.intercept('#interceptingPage', new RoadcrewInterceptor(_(dispatcher) {
    print("PRE INTECEPTING");
    dispatcher();
    print("POST INTECEPTING");
  }));

  Roadcrew.intercept('#troublePage', new RoadcrewInterceptor(_(dispatcher) {
    throw new RoadcrewException("I made trouble");
  }), (e) {
    DivElement errorPage = query('#errorPage');
    errorPage.query('.error').text = e.message;
    Roadcrew.flip(errorPage);
  });

  Roadcrew.intercept('#evenMoreTroublePage', new RoadcrewInterceptor(_(dispatcher) {
    throw new RoadcrewException("Even more trouble");
  }));

  Roadcrew.globalErrorHandler = (e) {
    DivElement errorPage = query('#errorPage');
    errorPage.query('.error').text = e.message;
    Roadcrew.flip(errorPage);
  };
}