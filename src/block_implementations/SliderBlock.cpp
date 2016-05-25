// Copyright (c) 2016 Electronic Theatre Controls, Inc., http://www.etcconnect.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#include "SliderBlock.h"

#include "MainController.h"
#include "NodeBase.h"
#include "utils.h"


QJsonObject SliderBlock::getState() const {
	QJsonObject state;
	state["guiItemHeight"] = getGuiItemConst()->height();
	return state;
}

void SliderBlock::setState(const QJsonObject &state) {
	if (state["guiItemHeight"].toDouble() > 0) {
		getGuiItem()->setHeight(state["guiItemHeight"].toDouble());
	}
}

void SliderBlock::onControllerPressed() {
	m_valueBeforeFlash = getValue();
	getGuiItemChild("slider")->setProperty("value", m_valueBeforeFlash < 0.99 ? 1 : 0);
	m_controller->powermate()->setBrightness(1.);
}

void SliderBlock::onControllerReleased(double) {
	getGuiItemChild("slider")->setProperty("value", m_valueBeforeFlash);
	m_controller->powermate()->setBrightness(m_valueBeforeFlash);
}

void SliderBlock::onControllerRotated(double value, bool) {
    double newValue = getValue() + value;
    getGuiItemChild("slider")->setProperty("value", limit(0., newValue, 1.));
	m_controller->powermate()->setBrightness(newValue);
}