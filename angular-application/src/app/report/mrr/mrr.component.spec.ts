import { ComponentFixture, TestBed } from '@angular/core/testing';
import { TestingModules } from 'src/app/common/common.modules';

import { MrrComponent } from './mrr.component';

describe('MrrComponent', () => {
  let component: MrrComponent;
  let fixture: ComponentFixture<MrrComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ MrrComponent ],
      imports: [TestingModules]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(MrrComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
