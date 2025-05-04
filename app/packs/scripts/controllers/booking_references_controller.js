import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static get targets() {
    return ['name', 'number', 'dataField', 'tbody', 'table', 'warning'];
  }

  connect() {
    this.references = [];
    this.loadFromField(); // Load existing references if they exist.
    this.render();
  }

  // Add a new reference to the list
  addReference() {
    const name = this.nameTarget.value.trim();
    const number = this.numberTarget.value.trim();

    this.showWarning(''); // Clear previous warnings

    if (!name || !number) return;

    // Check if the reference already exists (both name and number)
    if (this.references.some((ref) => ref.name === name)) {
      this.showWarning('A booking reference with this name already exists.');
      return;
    } if (this.references.some((ref) => ref.number === number)) {
      this.showWarning('A booking reference with this reference number already exists.');
      return;
    }

    this.references.push({ name, number });
    this.updateField();
    this.render();

    this.nameTarget.value = '';
    this.numberTarget.value = '';
  }

  // Remove a reference from the list
  deleteReference(event) {
    const { index } = event.currentTarget.dataset;
    this.references.splice(index, 1);
    this.updateField();
    this.render();
  }

  render() {
    this.tbodyTarget.innerHTML = '';

    if (this.references.length <= 0) {
      this.tableTarget.classList.add('d-none');
    } else {
      this.tableTarget.classList.remove('d-none');

      this.references.forEach((ref, index) => {
        const row = document.createElement('tr');

        // Sanitise inputs and buttons by setting textContent
        const nameCell = document.createElement('td');
        nameCell.textContent = ref.name;

        const numberCell = document.createElement('td');
        numberCell.textContent = ref.number;

        const deleteButtonCell = document.createElement('td');
        const button = document.createElement('button');
        button.type = 'button';
        button.classList.add('btn', 'btn-sm', 'btn-danger');
        button.setAttribute('data-action', 'booking-references#deleteReference');
        button.setAttribute('data-index', index);
        button.setAttribute('aria-label', `Delete Booking Reference with name ${ref.name} and number ${ref.number}`);
        button.textContent = 'Delete';

        deleteButtonCell.appendChild(button);

        row.appendChild(nameCell);
        row.appendChild(numberCell);
        row.appendChild(deleteButtonCell);

        this.tbodyTarget.appendChild(row);
      });
    }
  }

  // Update the hidden input field with the current references to synchronise with the server
  updateField() {
    this.dataFieldTarget.value = JSON.stringify(this.references);
  }

  // For the edit page, reload existing references from the hidden input field
  loadFromField() {
    try {
      const existing = this.dataFieldTarget.value;
      if (existing) this.references = JSON.parse(existing);
    } catch (e) {
      this.references = [];
    }
  }

  // Show a warning message, updating a text element beneath the input fields
  showWarning(message) {
    this.warningTarget.textContent = message;
  }
}
