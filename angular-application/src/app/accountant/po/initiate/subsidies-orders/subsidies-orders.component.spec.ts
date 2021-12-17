import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { SubsidiesOrdersComponent } from './subsidies-orders.component';

describe('SubsidiesOrdersComponent', () => {
  let component: SubsidiesOrdersComponent;
  let fixture: ComponentFixture<SubsidiesOrdersComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ SubsidiesOrdersComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(SubsidiesOrdersComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
