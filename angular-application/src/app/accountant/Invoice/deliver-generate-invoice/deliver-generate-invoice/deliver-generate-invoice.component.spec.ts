import { ComponentFixture, TestBed } from '@angular/core/testing';

import { DeliverGenerateInvoiceComponent } from './deliver-generate-invoice.component';
import { TestingModules, TestingProviders } from 'src/app/common/common.modules';

describe('DeliverGenerateInvoiceComponent', () => {
  let component: DeliverGenerateInvoiceComponent;
  let fixture: ComponentFixture<DeliverGenerateInvoiceComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ DeliverGenerateInvoiceComponent ],
      imports: [TestingModules],
      providers: [TestingProviders]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(DeliverGenerateInvoiceComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
