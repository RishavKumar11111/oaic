import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';

import { CancellationRoutingModule } from './cancellation-routing.module';
import { CancellationComponent } from './cancellation/cancellation.component';
import { FormsModule } from '@angular/forms';
import { SharedModule } from 'src/app/shared/shared.module';


@NgModule({
  declarations: [
    CancellationComponent
  ],
  imports: [
    CommonModule,
    CancellationRoutingModule,
    FormsModule,
    SharedModule
  ]
})
export class CancellationModule { }
