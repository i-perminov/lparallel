;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;;; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;;; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
;;; A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
;;; HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
;;; SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
;;; LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
;;; DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
;;; THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
;;; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
;;; OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

(in-package #:lparallel.kernel)

(deftype scheduler () 'biased-queue)

(alias-function make-scheduler make-biased-queue)

(defun/inline schedule-task (scheduler task priority)
  (ccase priority
    (:default (push-biased-queue     task scheduler))
    (:low     (push-biased-queue/low task scheduler))))

(defun/inline find-task (scheduler worker)
  (declare (ignore worker))
  (pop-biased-queue scheduler))

(defmacro with-locked-scheduler (scheduler &body body)
  `(with-locked-biased-queue ,scheduler
     ,@body))

(alias-function scheduler-empty-p/no-lock biased-queue-empty-p/no-lock)

(defun distribute-tasks/no-lock (scheduler tasks)
  (map nil
       (lambda (task) (push-biased-queue/no-lock task scheduler))
       tasks))
