#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <semaphore.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>

#define SHM_NAME "/my_shm"
#define SEM_CHILD_NAME "/sem_child"
#define SEM_PARENT_NAME "/sem_parent"
#define MAX_ITER 5

int running = 1;

void handle_sigint(int sig) {
    running = 0;
}

int main() {
    int shm_fd;
    char *shm_ptr;
    sem_t *sem_child, *sem_parent;
    pid_t pid;
    signal(SIGINT, handle_sigint);
    shm_fd = shm_open(SHM_NAME, O_CREAT | O_RDWR, 0666);
    if (shm_fd == -1) {
        perror("shm_open");
        exit(EXIT_FAILURE);
    }
    ftruncate(shm_fd, 1024);
    shm_ptr = mmap(0, 1024, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
    if (shm_ptr == MAP_FAILED) {
        perror("mmap");
        exit(EXIT_FAILURE);
    }
    sem_parent = sem_open(SEM_PARENT_NAME, O_CREAT, 0666, 0);
    sem_child = sem_open(SEM_CHILD_NAME, O_CREAT, 0666, 0);
    if (sem_parent == SEM_FAILED || sem_child == SEM_FAILED) {
        perror("sem_open");
        exit(EXIT_FAILURE);
    }

    pid = fork();
    if (pid < 0) {
        perror("fork");
        exit(EXIT_FAILURE);
    }

    if (pid == 0) { 
        
        shm_fd = shm_open(SHM_NAME, O_RDWR, 0666);
        if (shm_fd == -1) {
            perror("shm_open child");
            exit(EXIT_FAILURE);
        }
        shm_ptr = mmap(0, 1024, PROT_READ | PROT_WRITE, MAP_SHARED, shm_fd, 0);
        if (shm_ptr == MAP_FAILED) {
            perror("mmap child");
            exit(EXIT_FAILURE);
        }

        for (int i = 0; i < MAX_ITER && running; i++) {
            sem_wait(sem_child); 
            if (!running) break;
            printf("Child received: %s\n", shm_ptr);
            strcpy(shm_ptr, "Hello from child");
            sem_post(sem_parent); 
        }

        
        munmap(shm_ptr, 1024);
        close(shm_fd);
        sem_close(sem_child);
        sem_close(sem_parent);
        exit(EXIT_SUCCESS);
    } else { 
        sleep(1); 
        for (int i = 0; i < MAX_ITER && running; i++) {
            strcpy(shm_ptr, "Hello from parent");
            sem_post(sem_child); 
            sem_wait(sem_parent); 
            if (!running) break;
            printf("Parent received: %s\n", shm_ptr);
        }
        kill(pid, SIGINT);
        wait(NULL);
        munmap(shm_ptr, 1024);
        close(shm_fd);
        sem_close(sem_parent);
        sem_close(sem_parent);
        shm_unlink(SHM_NAME);
        sem_unlink(SEM_PARENT_NAME);
        sem_unlink(SEM_CHILD_NAME);
    }

    return 0;
}
